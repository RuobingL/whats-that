import UIKit
import MBProgressHUD

 class PhotoIdentificationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource{

    var results = [GoogleVisionResults]()
    let googleVisionAPIManager = GoogleVisionManager()
    
    // connect to imageView
    @IBOutlet weak var imageViewLoad: UIImageView!
    
    // take a photo using camera or choose a photo from photo library
    func choosePhoto() {
        
        let image = UIImagePickerController()
        image.delegate = self

        let alertController = UIAlertController(title: "choose a photo", message: "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "take a photo", style: .default, handler: { (action) in
            image.sourceType = UIImagePickerControllerSourceType.camera
            self.present(image, animated: true, completion: nil)
            }))
        
        alertController.addAction(UIAlertAction(title: "photos", style: .default, handler: { (action) in
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(image, animated: true, completion: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: "cancel", style: .default, handler: { (action) in
            self.present(alertController, animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // pick an image to imageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageViewLoad.image = image
            // show progress bar
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            googleVisionAPIManager.fetchGoogleVisionAPIResult(image: image)
            
        }
        else{
            // error message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // connect tableView
    @IBOutlet weak var tableViewLoad: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        choosePhoto()
        googleVisionAPIManager.delegate = self as? GoogleVisionManagerDelegate
        tableViewLoad.dataSource = self
        tableViewLoad.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    // table view cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellLoad", for: indexPath) as! ResultTableViewCell
        cell.labelTextViewLoad?.text = results[indexPath.row].description
        cell.labelTextViewLoad2?.text = results[indexPath.row].score
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toPhotoDetailSegue", sender: results[indexPath.row].description)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let guest = segue.destination as! PhotoDetailsViewController
        guest.word = sender as! String
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PhotoIdentificationViewController: GoogleVisionManagerDelegate{
    func resultFound(googleVisionResult: [GoogleVisionResults]) {
        // hide progress bar

        print(googleVisionResult)
        self.results = googleVisionResult
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableViewLoad.reloadData()
        }
    }
    
    func resultNotFound() {
        // hide progress bar
        // MBProgressHUD.hide(for: self.view, animated: true)
        print("result not found")
    }
}
