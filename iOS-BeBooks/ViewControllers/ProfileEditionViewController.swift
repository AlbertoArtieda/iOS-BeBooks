import UIKit

class ProfileEditionViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var newImg: UIImageView!
    @IBOutlet weak var newUsername: UITextField!
    @IBOutlet weak var newName: UITextField!
    @IBOutlet weak var newEmail: UITextField!
    @IBOutlet weak var newAddress: UITextField!
    @IBOutlet weak var newCP: UITextField!
    @IBOutlet weak var newProvince: UITextField!
    @IBOutlet weak var newPhone: UITextField!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTextFields()
        // Do any additional setup after loading the view.
    }
    
    func formatTextFields() {
        let fields: [UITextField] = [newUsername, newName, newEmail, newAddress, newCP, newProvince, newPhone]
        
        for i in fields {
            i.layer.cornerRadius = 10
            i.layer.borderWidth = 0.5
        }
    }
    @IBAction func changePhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        newImg.image = image
        newImg.layer.cornerRadius = 60
        newImg.clipsToBounds = true
        newImg.isHidden = false
        dismiss(animated: true)
        let imageData = newImg.image?.jpegData(compressionQuality: 1)
        // Convert image Data to base64 encoded string
        let imageBase64String = imageData?.base64EncodedString(options: .lineLength64Characters)
        print(imageBase64String ?? "Could not encode image to Base64")
        print(imageBase64String!)
    }
    
    @IBAction func updateData(_ sender: UIButton) {
        let url =  URL(string:"http://127.0.0.1:8000/newbook")
        //Get data of existing UIImage
        let imageData = newImg.image?.jpegData(compressionQuality: 1)
        // Convert image Data to base64 encodded string
        let imageBase64String = imageData?.base64EncodedString(options: .lineLength64Characters)
        print(imageBase64String ?? "Could not encode image to Base64")
        let imagen: String?
        if newImg.isHidden {
            imagen = imageBase64String
        } else {
            imagen = ""
        }
        
        let libro: [String: String] = [
            "imagen": imagen!,
            "usuario": newUsername.text!,
            "nombre": newName.text!,
            "email": newEmail.text!,
            "direccion": newAddress.text!,
            "cp": newCP.text!,
            "provincia": newProvince.text!,
            "telefono": newPhone.text!,
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
