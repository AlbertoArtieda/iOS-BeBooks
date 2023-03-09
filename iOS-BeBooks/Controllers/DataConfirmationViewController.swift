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
    
    static var bookDBID: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookImage.image = BookManagingViewController.image
        bookName.text = BookManagingViewController.name
        
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
                doPayProccess()
                print("la fecha: \(Date())")
                self.performSegue(withIdentifier: "payConfirm", sender: nil)
                break
            }
        }
    }
    
    func doPayProccess() {
        let url =  URL(string:"https://bebooks.onrender.com/change")

        let actualDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let dateFormatted = formatter.string(from: actualDate)
        
        let body: [String: Any] = [
            "fecha": dateFormatted,
            "ID_user_compra": 0, // El 0 es sólo temporal, ya que se necesita para que el back reciba el json, luego el back pondrá bien 'ID_user_compra'
            "ID_user_vende": OtherProfileViewController.userID!,
            "ID_libro": DataConfirmationViewController.bookDBID!
        ]
        
        let finalBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(String(ViewController.token), forHTTPHeaderField: "token")
        request.httpBody = finalBody
                
        URLSession.shared.dataTask(with: request){ data, response, error in
        }.resume()
    }
}
