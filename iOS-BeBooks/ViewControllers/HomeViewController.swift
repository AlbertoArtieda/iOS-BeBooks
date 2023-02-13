import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    // Intercambiar estas imagenes por la consuta a los libros más buscados
    let bookImages: [String] = ["PruebaListViews", "PruebaListViews", "PruebaListViews", "PruebaListViews", "PruebaListViews", "PruebaListViews", "PruebaListViews", "PruebaListViews", "PruebaListViews"]
    
    let profileImages: [String] = ["ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", "ImgPerfil", ]
    
    @IBOutlet weak var scrollMostSearchedBooks: UICollectionView!
    @IBOutlet weak var scrollPeopleNearYou: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollMostSearchedBooks.delegate = self
        scrollMostSearchedBooks.dataSource = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Tener el control de cada collection view
        if collectionView == scrollMostSearchedBooks{
            print("algo 1")
            return bookImages.count
        }
        print("algo 2")
        return profileImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = scrollPeopleNearYou.dequeueReusableCell(withReuseIdentifier: "nearPeople", for: indexPath) as! NearPeopleCollectionViewCell
        
        cell.imgProfile.image = UIImage(named: profileImages[indexPath.row])
        
        if collectionView == scrollMostSearchedBooks {
            print("Entra a SCROLL DE LIBROS")
            let cell2 = scrollMostSearchedBooks.dequeueReusableCell(withReuseIdentifier: "mostSearched", for: indexPath) as! MostSearchedBooksCollectionViewCell
            
            cell2.mostSearchedBook.image = UIImage(named: bookImages[indexPath.row])
            return cell2
        }
        return cell
    }

}
