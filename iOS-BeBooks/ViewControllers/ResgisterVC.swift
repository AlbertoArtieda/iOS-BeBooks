
import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCP: UITextField!
    @IBOutlet weak var txtProvince: UIButton!
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var dropdownTable: UITableView!
    
    var dropdownItems: [String] = []

    override func viewDidLoad() {
        formatoTextField()
        txtCP.delegate = self
        txtPhone.delegate = self
        
        dropdownTable.delegate = self
        dropdownTable.dataSource = self
    }
    
    @IBAction func btnContinue_OnClick(_ sender: Any) {
        if (!checkNullOrEmpty()) {
            showAlert()
        }
        else {
            // Registrar usuario en la base de datos e ir a Login
            let url =  URL(string:"https://bebooks.onrender.com/register")

            let body: [String: Any] = [
                "nombre_apellidos": txtName.text ?? "",
                "email": txtEmail.text ?? "",
                "usuario": txtUser.text ?? "",
                "password": txtPass.text ?? "",
                "direccion": txtAddress.text ?? "",
                "cp": Int(txtCP.text!)!,
                "telefono": Int(txtPhone.text!)!
            ]
            let finalBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
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
                // Si el mensaje que devuelve es correcto accede a la app
                if let httpResponse = response as? HTTPURLResponse {
                    print("statusCode: \(httpResponse.statusCode)")
                                
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.sync{
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
            if (i!.hashValue == textFields.count && errors != 0)
            {
                return false
            }
        }
        if (txtConfirmPass.text != txtPass.text) {
            txtConfirmPass.layer.borderColor = UIColor.red.cgColor
            txtPass.layer.borderColor = UIColor.red.cgColor
            return false
        }
        if ((txtCP.text == "" || txtCP.text == nil) || txtCP.text?.count != 5) {
            txtCP.layer.borderColor = UIColor.red.cgColor
            return false
        }
        if ((txtPhone.text == "" || txtPhone.text == nil) || txtPhone.text?.count != 9) {
            txtPhone.layer.borderColor = UIColor.red.cgColor
            return false
        }
        return true
    }
    
    func formatoTextField() {
        txtName.layer.cornerRadius = 10
        txtName.layer.borderWidth = 0.5
        txtEmail.layer.cornerRadius = 10
        txtEmail.layer.borderWidth = 0.5
        txtUser.layer.cornerRadius = 10
        txtUser.layer.borderWidth = 0.5
        txtPass.layer.cornerRadius = 10
        txtPass.layer.borderWidth = 0.5
        txtConfirmPass.layer.cornerRadius = 10
        txtConfirmPass.layer.borderWidth = 0.5
        txtAddress.layer.cornerRadius = 10
        txtAddress.layer.borderWidth = 0.5
        txtCP.layer.cornerRadius = 10
        txtCP.layer.borderWidth = 0.5
        txtPhone.layer.cornerRadius = 10
        txtPhone.layer.borderWidth = 0.5
        txtProvince.layer.cornerRadius = 10
        txtProvince.layer.borderWidth = 0.5
        
        //txtProvince.layer.masksToBounds = true
        txtProvince.layer.cornerRadius = 10
        txtProvince.layer.borderWidth = 0.5
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
    
    func showAlert() {
        let alert = UIAlertController(title: "Error en el registro", message: "Comprueba los campos marcados en rojo", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: {action in}))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdownItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dropdownItems[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        txtProvince.setTitle(dropdownItems[indexPath.row], for: .normal)
        dropdownTable.isHidden = true
    }
    
    @IBAction func sshowProvinces(_ sender: UIButton) {
        let urlSession = URLSession.shared
        let url =  URL(string: "https://bebooks.onrender.com/getProvincias")
        
        urlSession.dataTask(with: url!) { data, response, error  in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data)
                print("El JSON -> \(String(describing: json))")
                for i in json as! [String]{
                    print(i)
                    self.dropdownItems.append(i)
                }
                DispatchQueue.main.async {
                    self.dropdownTable.reloadData()
                    self.dropdownTable.isHidden = false
                }
            }
            
        }.resume()
    }
    
}
