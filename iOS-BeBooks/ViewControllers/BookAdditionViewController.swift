import UIKit

class BookAdditionViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var isbn: UITextField!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var editoial: UILabel!
    @IBOutlet weak var curso: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    var dataToFill: [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isbn.text = "Asdfas"
        dataToFill = [titulo, curso, editoial]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func fillData(_ sender: UIButton) {
        // 9788467587142 http://127.0.0.1:8000
        let url =  URL(string:"http://127.0.0.1:8000/getbookinfo")

        let isbn: [String: String] = [
            "isbn": isbn.text!
        ]
        
        let finalBody = try? JSONSerialization.data(withJSONObject: isbn, options: .prettyPrinted)
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = finalBody
        } catch let error {
            print("El Error\(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            
            print("El Response \(String(describing: response))")
            
            let json =  try? JSONSerialization.jsonObject(with: data!)
            
            if json == nil {
                print("el resultado ha sido NIL")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error en la búsqueda", message: "No es un libro normalmente utilizado en colegios e institutos", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: {action in}))
                    
                    self.present(alert, animated: true)
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
    
    @IBAction func addBookPhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        imagen.isHidden = false
        imagen.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBook(_ sender: UIButton) {
        if imagen.isHidden == false {
            print("Adelante")
            let url =  URL(string:"http://127.0.0.1:8000/getbookinfo")
            
            //Get data of existing UIImage
            
            let libro: [String: String] = [
                "isbn": isbn.text!,
                "imagen": "laimagenaqui",
                "titulo": titulo.text!,
                "editorial": editoial.text!,
                "curso": curso.text!
            ]
            
            let finalBody = try? JSONSerialization.data(withJSONObject: libro, options: .prettyPrinted)
            
            var request = URLRequest(url: url!)
            
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            do {
                request.httpBody = finalBody
            } catch let error {
                print("El Error\(error.localizedDescription)")
                return
            }
        }
    }
}
