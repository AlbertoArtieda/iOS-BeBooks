
import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
   
    @IBOutlet weak var isbnSearchBar: UISearchBar!
    @IBOutlet weak var peopleNearYou: UILabel!
    @IBOutlet weak var pnyCollection: UICollectionView!
    @IBOutlet weak var recentlyUploaded: UILabel!
    
    static var books : [Book] = []
    var nearPerson: [NearPerson] = []
    
    @IBOutlet weak var tableViewBooks: UITableView!
    @IBOutlet weak var scrollNearPeople: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNearPeople()
        BooksApi()
        catchUserInfo()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearPerson.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = scrollNearPeople.dequeueReusableCell(withReuseIdentifier: "nearPeople", for: indexPath) as! NearPeopleCollectionViewCell
        

        
        let dataDecoded : Data = Data(base64Encoded: nearPerson[indexPath.row].imagen_perfil, options: .ignoreUnknownCharacters) ?? Data()
        let decodedimage = UIImage(data: dataDecoded)
        
        cell.nearPerson.image = decodedimage
        cell.nearPerson.contentMode = .scaleAspectFill
        cell.nearPerson.layer.cornerRadius = 40
        cell.nearPerson.clipsToBounds = true

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == scrollNearPeople {
            print("Seleccionado!!!!")
        }
        print("Seleccionado!!!!")
        OtherProfileViewController.name = nearPerson[indexPath.row].nombre_apellidos

        let dataDecoded : Data = Data(base64Encoded: nearPerson[indexPath.row].imagen_perfil, options: .ignoreUnknownCharacters) ?? Data()
        let decodedimage = UIImage(data: dataDecoded)

        OtherProfileViewController.image = decodedimage
        OtherProfileViewController.userID = nearPerson[indexPath.row].ID_usuario
        print("Seleccioado")
        
        self.performSegue(withIdentifier: "seeProfile", sender: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchViewController.books.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewBooks.dequeueReusableCell(withIdentifier: "recentBook", for: indexPath) as! BookTableViewCell
        
        cell.bookTitle.text = SearchViewController.books[indexPath.row].titulo
        cell.bookISBN.text = "ISBN: " + SearchViewController.books[indexPath.row].isbn
        
        let dataDecoded : Data = Data(base64Encoded: SearchViewController.books[indexPath.row].imagen_libro, options: .ignoreUnknownCharacters) ?? Data()
        let decodedimage = UIImage(data: dataDecoded)
        
        cell.bookImage.image = decodedimage
        
        //ProfileViewController.recBooks.append(decodedimage ?? UIImage())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataDecoded : Data = Data(base64Encoded: SearchViewController.books[indexPath.row].imagen_libro, options: .ignoreUnknownCharacters) ?? Data()
        let decodedimage = UIImage(data: dataDecoded)
        
        BookManagingViewController.image = decodedimage
        BookManagingViewController.name = SearchViewController.books[indexPath.row].titulo
        BookManagingViewController.isbn = SearchViewController.books[indexPath.row].isbn
        
        BookManagingViewController.ownerID = SearchViewController.books[indexPath.row].ID_usuario
        print("La ID: " + String(BookManagingViewController.ownerID))
        
        print("Hsciendo segue")
        self.performSegue(withIdentifier: "seeBook", sender: nil)
    }
    
    func BooksApi() {
        
        guard let url = URL(string: "http://127.0.0.1:8000/searchBooks") else { return }
        
        URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            
            guard let data = data else { return }
        
            do {
                let decoder = JSONDecoder()
                SearchViewController.books = try decoder.decode([Book].self, from: data)
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
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                ViewController.user = try decoder.decode(User.self, from: data)

            } catch let error {
                print("Error: ", error)
            }
        }.resume()
    }
    
    func getNearPeople() {
        guard let url = URL(string: "http://127.0.0.1:8000/nearUsers") else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(ViewController.token, forHTTPHeaderField: "token")
        
        print("El token : " + ViewController.token)
        
        URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
            
            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                self.nearPerson = try decoder.decode([NearPerson].self, from: data)
                print("Las personas: \(self.nearPerson.count)")
                DispatchQueue.main.async {
                    self.scrollNearPeople.reloadData()
                    
                }

            } catch let error {
                print("Error: ", error)
            }
        }.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: filtrar por el texto del search bar
    }
}
