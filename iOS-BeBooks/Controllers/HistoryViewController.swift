import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var givenBooksTable: UITableView!
    @IBOutlet weak var gottenBooksTable: UITableView!
    var givenBooks: [ChangedBook] = []
    var gottenBooks: [ChangedBook] = []
    var prueba: [[String: Any]] = [[:]]

    override func viewDidLoad() {
        givenBooksApi()
        super.viewDidLoad()
        givenBooksTable.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == gottenBooksTable {
            
            return gottenBooks.count
            
        }
        
        return givenBooks.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = givenBooksTable.dequeueReusableCell(withIdentifier: "givenBook", for: indexPath) as! BookTableViewCell
        
        cell.bookTitle.text = givenBooks[indexPath.row].titulo
        
        cell.bookISBN.text = givenBooks[indexPath.row].isbn
        
        cell.tradeDate.text = givenBooks[indexPath.row].fecha
        
        //        cell.bookImage.image. = givenBooks[indexPath.row].imagen
        
        
        
        if tableView == gottenBooksTable {
            
            let cell2 = gottenBooksTable.dequeueReusableCell(withIdentifier: "gottenBook", for: indexPath) as! BookTableViewCell
            
            cell2.bookTitle.text = gottenBooks[indexPath.row].titulo
            
            cell2.bookISBN.text = gottenBooks[indexPath.row].isbn
            
            cell2.tradeDate.text = gottenBooks[indexPath.row].fecha
            
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
                    self.gottenBooksTable.reloadData()
                }
            } catch let error {
                print("Error: ", error)
            }
        }.resume()
    }
    
}
