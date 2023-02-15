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
        dismiss(animated: true)
    }
}
