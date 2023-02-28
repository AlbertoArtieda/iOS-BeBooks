import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var points: UILabel!
    
    @IBOutlet weak var recBooksCollection: UICollectionView!
    var interestingBooks: [RecommendedBookCollectionViewCell] = []
    
    @IBOutlet weak var uploadedBooksTable: UITableView!
    var uploadedBooks: [BookTableViewCell] = []
    
    var profileData: [Any] = []
    var personalData: [String: Any] = [:]
    var recommendedBooks: [[String: Any]] = [[:]]
    var personalBooks: [[String: Any]] = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillInterestingBooks()
        recBooksCollection.reloadData()
        print(recommendedBooks)
        // Do any additional setup after loading the view.
    }
    
    // Libros interesantes
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(recommendedBooks)
        return recommendedBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = recBooksCollection.dequeueReusableCell(withReuseIdentifier: "recBook", for: indexPath) as! RecommendedBookCollectionViewCell

        let dataDecoded : Data = Data(base64Encoded: self.recommendedBooks[indexPath.row]["imagen_libro"] as! String, options: .ignoreUnknownCharacters)!
        let decodedimage = UIImage(data: dataDecoded)
        
        cell.recBookImage.image = decodedimage
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
    
    func fillInterestingBooks() {
        let url =  URL(string:"http://127.0.0.1:8000/personalProfile")

        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(ViewController.token, forHTTPHeaderField: "token")
        print(ViewController.token)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data)
                for i in json as! [Any] {
                    self.profileData.append(i)
                }
                
                self.personalData = self.profileData[0] as! [String : Any]
                
                
                
//                print("1 - \(self.personalData)")
//                print("2 - \(self.recommendedBooks)")
//                print("3 - \(self.personalBooks)")
                
                let dataDecoded : Data = Data(base64Encoded: self.personalData["imagen_perfil"] as! String, options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                //self.recommendedBooks = self.profileData[1] as! [[String : Any]]
                self.recommendedBooks = self.profileData[1] as! [[String : Any]]
                self.personalBooks = self.profileData[2] as! [[String : Any]]
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    
                    self.name.text = self.personalData["nombre_apellidos"] as? String
                    self.points.text! += (self.personalData["puntos"] as? String)!
                    self.image.image = decodedimage
                    self.image.layer.cornerRadius = 40
                    self.image.clipsToBounds = true
                    self.recBooksCollection.reloadData()
                    
                    self.recommendedBooks = self.profileData[1] as! [[String : Any]]
                    self.personalBooks = self.profileData[2] as! [[String : Any]]

                }
                
            }
            
        }.resume()
        
    }
}
