
import UIKit

class RegisterVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCP: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    
    override func viewDidLoad() {
        formatoTextField()
        txtCP.delegate = self
        txtPhone.delegate = self
    }
    
    @IBAction func btnContinue_OnClick(_ sender: Any) {
        if (!checkNullOrEmpty()) {
            showAlert()
        }
        else {
            performSegue(withIdentifier: "Continue", sender: sender)
        }
    }
    
    func checkNullOrEmpty() -> Bool {
        var textFields = [txtName, txtEmail, txtUser, txtPass, txtConfirmPass, txtAddress, txtCP, txtPhone]
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
    
    
}
