import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var points: UILabel!
    
    @IBOutlet weak var recBooksCollection: UICollectionView!
    static var recBooks: [UIImage] = []
    
    @IBOutlet weak var uploadedBooksTable: UITableView!
    var personalBooks: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = ViewController.user.nombre_apellidos
        points.text = "Puntos: " + String(ViewController.user.puntos)
        
        let dataDecoded : Data = Data(base64Encoded: ViewController.user.imagen_perfil, options: .ignoreUnknownCharacters) ?? Data()
        let decodedimage = UIImage(data: dataDecoded)

        image.image = decodedimage
        image.layer.cornerRadius = 40
        image.clipsToBounds = true
        
        fillUploadedBooks()
        print(ProfileViewController.recBooks.count)
        recBooksCollection.reloadData()
        // Do any additional setup after loading the view.
    }
    
    // Libros interesantes
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileViewController.recBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = recBooksCollection.dequeueReusableCell(withReuseIdentifier: "recBook", for: indexPath) as! RecommendedBookCollectionViewCell

        cell.recBookImage.setImage(ProfileViewController.recBooks[indexPath.row], for: .normal)
        
        return cell
    }
    
    // Libros subidos
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personalBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = uploadedBooksTable.dequeueReusableCell(withIdentifier: "uploadedBook", for: indexPath) as! BookTableViewCell
        cell.bookTitle.text = personalBooks[indexPath.row].titulo
        cell.bookISBN.text = personalBooks[indexPath.row].isbn
        
        let dataDecoded : Data = Data(base64Encoded: personalBooks[indexPath.row].imagen_libro, options: .ignoreUnknownCharacters) ?? Data()
        let decodedimage = UIImage(data: dataDecoded)
        
        cell.bookImage.image = decodedimage
        // TODO: asignar a las propiedades de la celda creada (imagen, título y libro) las recibidas por HTTP y devolver la celda

        
        return cell
    }
    
    func fillUploadedBooks() {
        guard let url = URL(string: "http://127.0.0.1:8000/personalProfile") else { return }
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
