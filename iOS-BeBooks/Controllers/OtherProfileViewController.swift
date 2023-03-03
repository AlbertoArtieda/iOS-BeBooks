
import UIKit

class OtherProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var uploadedBooksTable: UITableView!
    
    static var userID: Int!
    static var image: UIImage!
    static var name: String!
    
    var userBooks: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.image = OtherProfileViewController.image
        profileName.text = OtherProfileViewController.name
        loadUserBooks()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = uploadedBooksTable.dequeueReusableCell(withIdentifier: "uploadedBook", for: indexPath) as! BookTableViewCell
        
        cell.bookTitle.text = userBooks[indexPath.row].titulo
        cell.bookISBN.text = userBooks[indexPath.row].isbn
        
        let dataDecoded : Data = Data(base64Encoded: userBooks[indexPath.row].imagen_libro, options: .ignoreUnknownCharacters) ?? Data()
        let decodedimage = UIImage(data: dataDecoded)
        
        cell.bookImage.image = decodedimage
        
        return cell
    }
    
    func loadUserBooks() {
        guard let url = URL(string: "http://127.0.0.1:8000/seeProfile") else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(String(OtherProfileViewController.userID), forHTTPHeaderField: "id")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                self.userBooks = try decoder.decode([Book].self, from: data)
                
                DispatchQueue.main.async {
                    self.uploadedBooksTable.reloadData()
                }

            } catch let error {
                print("Error: ", error)
            }
        }.resume()
    }

}
