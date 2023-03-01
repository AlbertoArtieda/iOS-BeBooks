
import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UICollectionViewDataSource {
   
    @IBOutlet weak var peopleNearYou: UILabel!
    @IBOutlet weak var pnyCollection: UICollectionView!
    @IBOutlet weak var recentlyUploaded: UILabel!
    @IBOutlet weak var ruTable: UITableView!
    
    let profileImages: [String] = ["ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", ]
    var books : [Book] = []
    static var interestingBooks: [UIImage] = []
    
    @IBOutlet weak var tableViewBooks: UITableView!
    @IBOutlet weak var scrollNearPeople: UICollectionView!
    @IBOutlet weak var btnSearch: UIButton!
    
    override func viewDidLoad() {
        BooksApi()
        super.viewDidLoad()
        tableViewBooks.dataSource = self
        btnSearch.layer.cornerRadius = 10
        catchUserInfo()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = scrollNearPeople.dequeueReusableCell(withReuseIdentifier: "nearPeople", for: indexPath) as! NearPeopleCollectionViewCell
        cell.nearPerson.setImage(UIImage(named: profileImages[indexPath.row]), for: .normal)
        //cell.nearPerson.setImage(UIImage(named: profileImages[indexPath.row]), for: .application)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewBooks.dequeueReusableCell(withIdentifier: "recentBook", for: indexPath) as! BookTableViewCell
        
        cell.bookTitle.text = books[indexPath.row].titulo
        cell.bookISBN.text = "ISBN: " + books[indexPath.row].isbn
        
        let dataDecoded : Data = Data(base64Encoded: books[indexPath.row].imagen_libro, options: .ignoreUnknownCharacters) ?? Data()
        let decodedimage = UIImage(data: dataDecoded)
        
        cell.bookImage.image = decodedimage
        
        ProfileViewController.recBooks.append(decodedimage ?? UIImage())
        
        return cell
    }
    
    func BooksApi() {
        
        guard let url = URL(string: "https://bebooks.onrender.com/searchBooks") else { return }
        
        URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            
            guard let data = data else { return }
        
            do {
                let decoder = JSONDecoder()
                self.books = try decoder.decode([Book].self, from: data)
                DispatchQueue.main.async {
                    self.tableViewBooks.reloadData()
                }
                    
            } catch let error {
                print("Error: ", error)
            }
        }.resume()
        
    }
    func catchUserInfo() {
        guard let url = URL(string: "https://bebooks.onrender.com/userData") else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(ViewController.token, forHTTPHeaderField: "token")
        print("El token \(ViewController.token)")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                ViewController.user = try decoder.decode(User.self, from: data)
                print("El usuario \(String(describing: ViewController.user))")

            } catch let error {
                print("Error: ", error)
            }
        }.resume()
    }
    
    @IBAction func searchBook(_ sender: UIButton) {
        let elementsToHide = [peopleNearYou, pnyCollection, recentlyUploaded, ruTable]
        for i in elementsToHide {
            i?.isHidden = true
        }
        
        // TODO: fix errors below
        guard let url = URL(string: "http://127.0.0.1:8000/nearPeople") else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(ViewController.token, forHTTPHeaderField: "token")
        
        URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
            
            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                self.personalBooks = try decoder.decode([Book].self, from: data)
                print(self.personalBooks)
                DispatchQueue.main.async {
                    self.uploadedBooksTable.reloadData()
                    
                }

            } catch let error {
                print("Error: ", error)
            }
        }.resume()
    }

}
