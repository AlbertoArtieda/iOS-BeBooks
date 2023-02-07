
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var message: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        message.isHidden = true
        formatoTextField()
    }
    
    func formatoTextField() {
        txtUser.layer.cornerRadius = 10
        txtUser.layer.borderWidth = 0.5
        txtPass.layer.cornerRadius = 10
        txtPass.layer.borderWidth = 0.5
    }

    @IBAction func btnEntrar_OnClick(_ sender: Any) {
        // Si el nombre o la contraseña están vacíos muestra un mensaje e impide acceder
        if (txtUser.text == "" || txtPass.text == ""){
            message.isHidden = false
            return
        }
        
        guard let url =  URL(string:"https://bebooks.onrender.com/login")
                else{
                    return
                }
        let body: [String: String] = ["nombre": txtUser.text ?? "", "password": txtPass.text ?? ""]
                let finalBody = try? JSONSerialization.data(withJSONObject: body)
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = finalBody
                
                URLSession.shared.dataTask(with: request){
                    (data, response, error) in
                    print(response as Any)
                    if let error = error {
                        print(error)
                        return
                    }
                    // Si el mensaje que devuelve es correcto accede a la app
                    if let httpResponse = response as? HTTPURLResponse {
                        print("statusCode: \(httpResponse.statusCode)")
                        
                        if httpResponse.statusCode == 201 {
                            DispatchQueue.main.sync{
                                self.performSegue(withIdentifier: "Entry", sender: sender)
                            }
                        }
                    }
                    else {
                        self.message.isHidden = false
                    }
                    
                }.resume()
    }
}

