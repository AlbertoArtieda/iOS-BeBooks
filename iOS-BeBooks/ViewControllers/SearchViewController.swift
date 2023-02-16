
import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UICollectionViewDataSource {
   
    let profileImages: [String] = ["ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", ]
    var books : [Book] = []
    
    
    @IBOutlet weak var tableViewBooks: UITableView!
    @IBOutlet weak var scrollNearPeople: UICollectionView!
    @IBOutlet weak var btnSearch: UIButton!
    
    override func viewDidLoad() {
        BooksApi()
        super.viewDidLoad()
        tableViewBooks.dataSource = self
        btnSearch.layer.cornerRadius = 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = scrollNearPeople.dequeueReusableCell(withReuseIdentifier: "nearPeople", for: indexPath) as! NearPeopleCollectionViewCell
        
        cell.imgProfile.image = UIImage(named: profileImages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewBooks.dequeueReusableCell(withIdentifier: "recentBook", for: indexPath) as! BookTableViewCell
        
        cell.bookTitle.text = books[indexPath.row].titulo
        cell.bookISBN.text = "ISBN: " + books[indexPath.row].isbn
        
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
    


}
