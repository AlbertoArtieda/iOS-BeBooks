import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var givenBooksTable: UITableView!
    @IBOutlet weak var gottenBooksTable: UITableView!
    var givenBooks: [BookTableViewCell] = []
    var gottenBooks: [BookTableViewCell] = []

    override func viewDidLoad() {
        super.viewDidLoad()

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
        // TODO: asignar a las propiedades de la celda creada (imagen, título, libro y fecha) las recibidas por HTTP y devolver la celda
        if tableView == gottenBooksTable {
            let cell2 = gottenBooksTable.dequeueReusableCell(withIdentifier: "gottenBook", for: indexPath) as! BookTableViewCell
            // TODO: asignar a las propiedades de la celda creada (imagen, título, libro y fecha) las recibidas por HTTP y devolver la celda
            return cell2
        }
        
        return cell
    }
}
