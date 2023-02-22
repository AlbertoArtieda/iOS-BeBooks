
import UIKit
import DropDown

class RegisterVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCP: UITextField!
    @IBOutlet weak var btnProvince: UIButton!
    @IBOutlet weak var txtPhone: UITextField!
    let dropDown = DropDown()
    var imagenPerfil = ""
    
    var dropdownItems: [String] = []

    override func viewDidLoad() {
        
        formatoTextField()
        txtCP.delegate = self
        txtPhone.delegate = self
        DispatchQueue.main.async {
            self.Provinces()
        }

    }
    
    @IBAction func btnContinue_OnClick(_ sender: Any) {
        
        if (!checkNullOrEmpty()) {
            ErrorAlert()
        }
        
        else {
            let url =  URL(string:"https://bebooks.onrender.com/register")

            var usuario: [String : Any] = [
                "nombre_apellidos" : txtName.text ?? "",
                "email" : txtEmail.text ?? "",
                "usuario" : txtUser.text ?? "",
                "password" : txtPass.text ?? "",
                "direccion" : txtAddress.text ?? "",
                "cp": Int(txtCP.text!) ?? 0,
                "telefono": Int(txtPhone.text!) ?? 0,
                "ID_provincia": dropDown.indexForSelectedRow! + 1,
                "token": "",
                "puntos": 0
                
            ]
            
            // Si se añade una imagen de perfil, la añade al JSON
            if imagenPerfil != "" {
                usuario["imagenPerfil"] = imagenPerfil
            }
            
            let finalBody = try? JSONSerialization.data(withJSONObject: usuario, options: .prettyPrinted)
            
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
                
                if let httpResponse = response as? HTTPURLResponse {
                    
                    print("statusCode: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.sync {
                            self.performSegue(withIdentifier: "Continue", sender: sender)
                            
                        }
                    }
                }
            }.resume()
        }
    }
    
    
    func checkNullOrEmpty() -> Bool {
        let textFields = [txtName, txtEmail, txtUser, txtPass, txtConfirmPass, txtAddress, txtCP, txtPhone]
        
        var errors = 0
        
        for i in textFields {
            i!.layer.borderColor = UIColor.black.cgColor
            if (i!.text == "" || i!.text == nil){
                i!.layer.borderColor = UIColor.red.cgColor
                errors += 1
            }
            
            if (i!.hashValue == textFields.count && errors > 0)
            {
                return false
            }
        }
        if (dropDown.indexForSelectedRow == nil){
            btnProvince.layer.borderColor = UIColor.red.cgColor
            return false
        }
        return true
    }
    
    func formatoTextField() {
        let textFields = [txtName, txtEmail, txtUser, txtPass, txtConfirmPass, txtAddress, txtCP, txtPhone, btnProvince]
        
        for i in textFields {
            i!.layer.cornerRadius = 10
            i!.layer.borderWidth = 0.5
        }
        dropDown.anchorView = btnProvince
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
        
        dropDown.direction = .bottom
        
        dropDown.selectionAction = { (index : Int, item : String) in
            
            self.btnProvince.titleLabel?.text = self.dropdownItems[index]
            
            self.btnProvince.titleLabel?.textColor = .black
            
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == txtCP || textField == txtPhone) {
            
            let allowedcharacters = "0123456789"
            let allowedcharacterSet = CharacterSet(charactersIn: allowedcharacters)
            let typedCharactersetIn = CharacterSet(charactersIn: string)
            let numbers = allowedcharacterSet.isSuperset(of: typedCharactersetIn)
            
            return numbers
        }
        
        return true
    }
    
    
    func ErrorAlert() {
        let alert = UIAlertController(title: "Error en el registro", message: "Comprueba los campos marcados en rojo", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: {action in}))
        
        present(alert, animated: true)
    }
    
    @IBAction func btnProvince_OnClick(_ sender: Any) {
        dropDown.show()
    }
    
    func Provinces() {
        let urlSession = URLSession.shared
        let url =  URL(string: "https://bebooks.onrender.com/getProvincias")
        
        urlSession.dataTask(with: url!) { data, response, error  in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data)

                for i in json as! [String]{
                    self.dropdownItems.append(i)
                    
                }
                
                DispatchQueue.main.async {
                    self.dropDown.dataSource = self.dropdownItems
                }
            }
        }.resume()
    }
    
    @IBAction func changePhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}

        dismiss(animated: true)
        let imageData = image.jpegData(compressionQuality: 1)
        // Convert image Data to base64 encoded string
        let imageBase64String = imageData?.base64EncodedString(options: .lineLength64Characters)
        imagenPerfil = imageBase64String ?? ""
    }
}
