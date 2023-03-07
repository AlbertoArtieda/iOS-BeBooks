import UIKit

class BookAdditionViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var isbn: UISearchBar!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var editoial: UILabel!
    @IBOutlet weak var curso: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    var dataToFill: [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isbn.text = "Asdfas"
        dataToFill = [titulo, curso, editoial]
        // Do any additional setup after loading the view.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 9788468087634 http://127.0.0.1:8000
        
        if searchText.count == 13 {
            let url =  URL(string:"http://127.0.0.1:8000/getbookinfo")
            
            var request = URLRequest(url: url!)
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(isbn.text, forHTTPHeaderField: "isbn")
            
            URLSession.shared.dataTask(with: request){ data, response, error in
                
                print("El Response \(String(describing: response))")
                
                let json =  try? JSONSerialization.jsonObject(with: data!)
                
                if json == nil {
                    print("el resultado ha sido NIL")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error en la búsqueda", message: "No es un libro normalmente utilizado en colegios e institutos", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: {action in}))
                        
                        self.present(alert, animated: true)
                        searchBar.text = ""
                    }
                    
                    
                } else {
                    print("el resultado ha sido EEXITOSO")
                    var filling: [String] = []
                    
                    for i in json as! [String] {
                        print(i)
                        filling.append(i)
                    }
                    for i in 0...filling.count - 1 {
                        DispatchQueue.main.async {
                            self.dataToFill[i].text = filling[i]
                        }
                    }
                }
            }.resume()
        }
        
    }

    
    @IBAction func addBookPhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        imagen.isHidden = false
        addImageButton.isHidden = true
        imagen.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBook(_ sender: UIButton) {
        
        if imagen.isHidden == false && titulo.text != "" && isbn.text != "" {
            print("Adelante")
            let url =  URL(string:"http://127.0.0.1:8000/newbook")
            let imageData = imagen.image?.jpegData(compressionQuality: 1)
            // Convert image Data to base64 encodded string
            let imagenFinal = (imageData?.base64EncodedString(options: .lineLength64Characters)) ?? ""
            print(ViewController.token)
            let libro: [String: String] = [
                "isbn": isbn.text!,
                "titulo": titulo.text!,
                "curso": curso.text!,
                "imagen_libro": imagenFinal,
                "editorial": editoial.text!
            ]
            
            let finalBody = try? JSONSerialization.data(withJSONObject: libro, options: .prettyPrinted)
            
            var request = URLRequest(url: url!)
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue(ViewController.token, forHTTPHeaderField: "token")
            request.httpBody = finalBody
            
            
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                DispatchQueue.main.sync{
                    self.tabBarController?.selectedIndex = 3
                }
            }.resume()
                
        } else {
            let alert = UIAlertController(title: "Error en la subida", message: "Se deben completar todos los campos para hacer una subida exitosa (imagen, título, editorial y curso)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: {action in}))
            
            self.present(alert, animated: true)
        }
    }
}
