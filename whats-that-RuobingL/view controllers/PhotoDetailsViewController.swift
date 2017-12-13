import UIKit

class PhotoDetailsViewController: UIViewController {

    var wikipediaAPIManager = WikipediaManager()

    @IBOutlet weak var textLabelTitle: UILabel!
    @IBOutlet weak var textViewLoad: UITextView!
    
    var  word = "word"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLabelTitle.text = word
        wikipediaAPIManager.delegate = self
        wikipediaAPIManager.fetchWikipediaResults(label: word)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PhotoDetailsViewController: WikipediaResultDelegate{
    func wikipediaResultFound(wikipediaResults: WikipediaResults) {
        print("find", wikipediaResults.extract)
        DispatchQueue.main.async {
            self.textViewLoad.text = wikipediaResults.extract
        }
    }
    
    func wikipediaResultNotFound() {
        print("result not found")
    }
}
