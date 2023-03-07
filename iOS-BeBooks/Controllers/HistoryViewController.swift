import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var givenBooksSearchBar: UISearchBar!
    @IBOutlet weak var gottenBooksSearchBar: UISearchBar!
    @IBOutlet weak var givenBooksTable: UITableView!
    @IBOutlet weak var gottenBooksTable: UITableView!
    var givenBooks: [ChangedBook] = []
    var gottenBooks: [ChangedBook] = []
    var prueba: [[String: Any]] = [[:]]
    
    var filterGivenBooks = [ChangedBook]()
    var filterGottenBooks = [ChangedBook]()

    override func viewDidLoad() {
        givenBooksApi()
        super.viewDidLoad()
        givenBooksTable.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == gottenBooksTable {
            return filterGottenBooks.count
        }
        return filterGivenBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = givenBooksTable.dequeueReusableCell(withIdentifier: "givenBook", for: indexPath) as! BookTableViewCell
        
        cell.bookTitle.text = filterGivenBooks[indexPath.row].titulo
        cell.bookISBN.text = filterGivenBooks[indexPath.row].isbn
        cell.tradeDate.text = filterGivenBooks[indexPath.row].fecha
        
        let dataDecoded : Data = Data(base64Encoded: filterGivenBooks[indexPath.row].imagen_libro, options: .ignoreUnknownCharacters) ?? Data()
        let decodedimage = UIImage(data: dataDecoded)
        cell.bookImage.image = decodedimage

        if tableView == gottenBooksTable {
            
            let cell2 = gottenBooksTable.dequeueReusableCell(withIdentifier: "gottenBook", for: indexPath) as! BookTableViewCell
            
            cell2.bookTitle.text = filterGottenBooks[indexPath.row].titulo
            cell2.bookISBN.text = filterGottenBooks[indexPath.row].isbn
            cell2.tradeDate.text = filterGottenBooks[indexPath.row].fecha
            
            let dataDecoded : Data = Data(base64Encoded: gottenBooks[indexPath.row].imagen_libro, options: .ignoreUnknownCharacters) ?? Data()
            let decodedimage = UIImage(data: dataDecoded)
            cell2.bookImage.image = decodedimage
            
            return cell2
            
        }

        return cell
    }

    func givenBooksApi() {
        
        guard let url = URL(string: "https://bebooks.onrender.com/givenBooks") else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(ViewController.token, forHTTPHeaderField: "token")
        
        URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
            
            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                self.givenBooks = try decoder.decode([ChangedBook].self, from: data)
                DispatchQueue.main.async {
                    self.filterGivenBooks = self.givenBooks
                    self.givenBooksTable.reloadData()
                }

            } catch let error {
                
                print("Error: ", error)
                
            }
        }.resume()
    }

    func gottenBooksApi() {
        guard let url = URL(string: "https://bebooks.onrender.com/gottenBooks") else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(ViewController.token, forHTTPHeaderField: "token")

        URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
            guard let data = data else { return }
            

            do {
                let decoder = JSONDecoder()
                self.gottenBooks = try decoder.decode([ChangedBook].self, from: data)
                DispatchQueue.main.async {
                    self.filterGottenBooks = self.gottenBooks
                    self.gottenBooksTable.reloadData()
                }
            } catch let error {
                print("Error: ", error)
            }
        }.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: filtrar por el texto del search bar
        if searchBar == givenBooksSearchBar {
            if searchBar.text != "" {
                filterGivenBooks = self.givenBooks.filter({$0.titulo.contains(searchText)})
                givenBooksTable.reloadData()
            } else {
                filterGivenBooks = self.givenBooks
                givenBooksTable.reloadData()
            }
        } else {
            if searchBar.text != "" {
                filterGottenBooks = self.gottenBooks.filter({$0.titulo.contains(searchText)})
                gottenBooksTable.reloadData()
            } else {
                filterGottenBooks = self.gottenBooks
                gottenBooksTable.reloadData()
            }
        }
    }
}
