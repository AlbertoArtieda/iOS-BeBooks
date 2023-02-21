import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var givenBooksTable: UITableView!
    @IBOutlet weak var gottenBooksTable: UITableView!
    var givenBooks: [ChangedBook] = []
    var gottenBooks: [ChangedBook] = []

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
//        cell.bookImage.image. = givenBooks[indexPath.row].imagen

        if tableView == gottenBooksTable {
            let cell2 = gottenBooksTable.dequeueReusableCell(withIdentifier: "gottenBook", for: indexPath) as! BookTableViewCell
            cell2.bookTitle.text = gottenBooks[indexPath.row].titulo
            cell2.bookISBN.text = gottenBooks[indexPath.row].isbn
            return cell2
        }
        
        return cell
    }
    
    func givenBooksApi() {
        let url =  URL(string:"https://bebooks.onrender.com/givenBooks")

        let body: [String: String] = ["nombre": "", "password": "", "token": token]
        let finalBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = finalBody
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            print(response as Any)
            if let error = error {
                print(error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
                
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
            }
                        
        }.resume()
    }
    
}
