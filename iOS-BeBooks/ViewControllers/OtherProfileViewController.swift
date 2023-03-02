
import UIKit

class OtherProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    static var image: UIImage!
    static var name: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Haciendo cambios...")
        profileImage.image = OtherProfileViewController.image
        profileName.text = OtherProfileViewController.name
        print("Hecho")
    }
    


}
