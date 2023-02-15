import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    // Intercambiar estas imagenes cuando llegue la hora
    let profileImages: [String] = ["ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", ]
    let recentlyUploaded: [BookTableViewCell] = []
    
    @IBOutlet weak var scrollNearPeople: UICollectionView!
    @IBOutlet weak var recentlyUploadedTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Gente cerca de uno
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = scrollNearPeople.dequeueReusableCell(withReuseIdentifier: "nearPeople", for: indexPath) as! NearPeopleCollectionViewCell
        
        cell.imgProfile.image = UIImage(named: profileImages[indexPath.row])
        return cell
    }
    
    // Libros recientemente subidps
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentlyUploaded.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recentlyUploadedTable.dequeueReusableCell(withIdentifier: "recentBook", for: indexPath) as! BookTableViewCell
        // TODO: asignar a las propiedades de la celda creada (imagen, título y libro) las recibidas por HTTP y devolver la celda
        return cell
    }

}
