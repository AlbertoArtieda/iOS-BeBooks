
import UIKit

class BookManagingViewController: UIViewController {
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookISBN: UILabel!
    
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var ownerName: UILabel!
    
    static var ownerID: Int!
    static var ownName: String!
    static var ownImage: UIImage!
    static var image: UIImage!
    static var name: String!
    static var isbn: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookImage.image = BookManagingViewController.image
        bookName.text = BookManagingViewController.name
        bookISBN.text = BookManagingViewController.isbn
        getOwner()
        // Do any additional setup after loading the view.
    }
    
    // TODO: getowner
    func getOwner() {
        guard let url = URL(string: "http://127.0.0.1:8000/showOwner") else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(String(BookManagingViewController.ownerID), forHTTPHeaderField: "id")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data)
                
                var personalData: [String: String] = [:]
                personalData = json as! [String:String]
                print("Los datos personales: \(personalData)")
                
                DispatchQueue.main.async {
                    
                    self.ownerName.text = personalData["nombre_apellidos"]
                    
                    let dataDecoded : Data = Data(base64Encoded: personalData["imagen_perfil"]!, options: .ignoreUnknownCharacters) ?? Data()
                    let decodedimage = UIImage(data: dataDecoded)
                    self.ownerImage.image = decodedimage
                }
            }
        }.resume()
    }
}
