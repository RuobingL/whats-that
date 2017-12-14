import UIKit
import SafariServices
import Social

class PhotoDetailsViewController: UIViewController {

    var wikipediaAPIManager = WikipediaManager()
    var wikiResult = WikipediaResults(title: "", extract: "")
    
    @IBOutlet weak var textLabelTitle: UILabel!
    @IBOutlet weak var textViewLoad: UITextView!
    
    var word = "word"

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let guest = segue.destination as! SearchTimelineViewController
        guest.query = sender as! String
    }
    
    // Wiki button
    @IBAction func wikiButtonPressed(_ sender: Any) {
        let svc = SFSafariViewController(url: URL(string: "http://www.wikipedia.org/wiki/\(word)")!)
        self.present(svc, animated: true, completion: nil)
    }
    
    // Twitter button
    @IBAction func twitterButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toTwitterSegue", sender: word)
    }
    
    // Share button
    @IBAction func shareButtonPressed(_ sender: Any) {
        // create the Alert
        let selectServiceAlert = UIAlertController(title: "Select Service", message: "Select Service", preferredStyle: .actionSheet)
        
        // create action buttons
        // facebook
        let facebookActionButton = UIAlertAction(title: "facebook", style: .default) { (action) in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                // create a post view
                let facebookPostView = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                // set default post
                facebookPostView?.setInitialText("what's that? Such a good app!")
                // display post view
                self.present(facebookPostView!, animated: true, completion: nil)
            } else {
                self.error(serviceType: "Facebook")
            }
        }
        // twitter
        let twitterActionButton = UIAlertAction(title: "twitter", style: .default) { (action) in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                // create a post view
                let twitterPostView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                // set default post
                twitterPostView?.setInitialText("what's that? Such a good app!")
                // display post view
                self.present(twitterPostView!, animated: true, completion: nil)
            } else {
                self.error(serviceType: "Twitter")
            }
        }
        // cancel
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // add actions to the alert
        selectServiceAlert.addAction(facebookActionButton)
        selectServiceAlert.addAction(twitterActionButton)
        selectServiceAlert.addAction(cancelActionButton)
        
        // display the alert
        self.present(selectServiceAlert, animated: true, completion: nil)
    }
    
    func error(serviceType: String) {
        // create alert
        let errorAlert = UIAlertController(title: "unavailable", message: "Your device is not connected to \(serviceType)", preferredStyle: .alert)
        // create the action
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        // add actions
        errorAlert.addAction(okAction)
        
        // display alert
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    // fav button
    @IBAction func favButtonPressed(_ sender: Any) {
        Persistance.sharedInstance.saveWikipediaResults(wikiResult)
    }
}

extension PhotoDetailsViewController: WikipediaResultDelegate{
    func wikipediaResultFound(wikipediaResults: WikipediaResults) {
        
        self.wikiResult = wikipediaResults
        
        print("find", wikipediaResults.extract)
        DispatchQueue.main.async {
            self.textViewLoad.text = wikipediaResults.extract
        }
    }
    
    func wikipediaResultNotFound() {
        print("result not found")
    }
}
