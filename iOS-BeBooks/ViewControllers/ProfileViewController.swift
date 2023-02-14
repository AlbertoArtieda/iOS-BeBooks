import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recBooksCollection: UICollectionView!
    var interestingBooks: [BookTableViewCell] = []
    
    @IBOutlet weak var uploadedBooksTable: UITableView!
    var uploadedBooks: [BookTableViewCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Libros interesantes
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interestingBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = recBooksCollection.dequeueReusableCell(withReuseIdentifier: "recBook", for: indexPath) as! RecommendedBookCollectionViewCell
        
        // TODO: asignar a las propiedades de la celda creada (imagen del libro) las recibidas por HTTP y devolver la celda
        return cell
    }
    
    // Libros subidos
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return uploadedBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = uploadedBooksTable.dequeueReusableCell(withIdentifier: "uploadedBook", for: indexPath) as! BookTableViewCell
        // TODO: asignar a las propiedades de la celda creada (imagen, título y libro) las recibidas por HTTP y devolver la celda

        
        return cell
    }

}
