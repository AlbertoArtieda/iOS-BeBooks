import UIKit

class BookAdditionViewController: UIViewController {
    
    @IBOutlet weak var isbn: UITextField!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var editoial: UILabel!
    @IBOutlet weak var curso: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isbn.text = "Asdfas"
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func fillData(_ sender: UIButton) {
        // 9788467587142
        print("algo")
        let isbn = isbn.text
        let urlSession = URLSession.shared
        let url =  URL(string: "https://www.googleapis.com/books/v1/volumes?q=" + isbn!)
        var recievedItems: Dictionary = [String:Any]()
        print("print")
        urlSession.dataTask(with: url!) { data, response, error in
            print("hola")
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data)
                for i in json as! [String: Any]{
                    print(i)
                }
            }
        }.resume()
    }
}
