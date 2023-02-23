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
        cell.bookISBN.text = String(givenBooks[indexPath.row].isbn)
//        cell.bookImage.image. = givenBooks[indexPath.row].imagen

        if tableView == gottenBooksTable {
            let cell2 = gottenBooksTable.dequeueReusableCell(withIdentifier: "gottenBook", for: indexPath) as! BookTableViewCell
            cell2.bookTitle.text = gottenBooks[indexPath.row].titulo
            cell2.bookISBN.text = String(gottenBooks[indexPath.row].isbn)
            return cell2
        }
        
        return cell
    }
    
    func givenBooksApi() {
        guard let url = URL(string: "https://bebooks.onrender.com/givenBooks") else { return }
        
        let token: [String: String] = [
            "nombre": "1",
            "password": "6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b",
            "token": "a08454ac64ae970bec0180dd13734fc731154d75c70274e1068762467ebe631d"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: token, options: .prettyPrinted)
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
                print("statusCode de los libros DADOS: \(httpResponse.statusCode)")

                guard let data = data else {return}

                do {
                    let decoder = JSONDecoder()
                    self.givenBooks = try decoder.decode([ChangedBook].self, from: data)
                    print(self.givenBooks)
                    print("aqui")
                    DispatchQueue.main.async {
                        self.givenBooksTable.reloadData()
                        print("aqui2")
                    }

                } catch let error {
                    print("Error: ", error)

                }

            }

                        
        }.resume()
    }
    
}
