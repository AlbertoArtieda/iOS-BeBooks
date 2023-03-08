import UIKit

class DataConfirmationViewController: UIViewController {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userNameLastName: UITextField!
    @IBOutlet weak var userAdress: UITextField!
    @IBOutlet weak var userCP: UITextField!
    @IBOutlet weak var userProvince: UITextField!
    @IBOutlet weak var userTelephone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataDecoded : Data = Data(base64Encoded: "aqui la imagen del libro", options: .ignoreUnknownCharacters) ?? Data()
        let decodedimage = UIImage(data: dataDecoded)
        
        userName.text = ViewController.user.usuario
        userNameLastName.text = ViewController.user.nombre_apellidos
        userAdress.text = ViewController.user.direccion
        userCP.text = String(ViewController.user.cp)
        userProvince.text = ViewController.user.provincia
        userTelephone.text = String(ViewController.user.telefono)
        // Do any additional setup after loading the view.
    }
    @IBAction func pay(_ sender: UIButton) {
        let fields = [userName, userNameLastName, userAdress, userCP, userProvince, userTelephone]
        for i in fields {
            if i?.text == "" {
                let alert = UIAlertController(title: "Error", message: "Asegúrate de completar todos los campos antes de proceder al pago", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: {action in}))
                
                self.present(alert, animated: true)
            } else {
                self.performSegue(withIdentifier: "payConfirm", sender: nil)
            }
        }
    }
    
}
