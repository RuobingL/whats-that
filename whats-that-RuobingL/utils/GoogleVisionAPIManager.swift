import Foundation
import UIKit

protocol GoogleVisionManagerDelegate {
    func resultFound(googleVisionResult: [GoogleVisionResults])
    func resultNotFound()
}

class GoogleVisionManager{
    
    var delegate: GoogleVisionManagerDelegate?
    
    func fetchGoogleVisionAPIResult(image: UIImage) {
        
        let base64image = UIImageJPEGRepresentation(image, 0.8)?.base64EncodedString()
        var urlComponents = URLComponents(string: "https://vision.googleapis.com/v1/images:annotate")!
        urlComponents.queryItems = [URLQueryItem(name: "key", value: "AIzaSyA_GXyMrP8BMMuMFTZo42J8U-Npepet9EI")]
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonRequest:[String: Any] = [
            "requests": [
                "image": ["content": base64image],
                "features": [["type": "LABEL_DETECTION"]]
            ]
        ]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: jsonRequest, options: [])
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200
                else{
                    self.delegate?.resultNotFound()
                    print("result not found")
                    return
            }
            guard let data = data
                else{
                    self.delegate?.resultNotFound()
                    print("result not found")
                    return
            }
            
            let decoder = JSONDecoder()
            let decodedRoot = try? decoder.decode(Root.self, from: data)
            guard let root = decodedRoot
                else{
                    self.delegate?.resultNotFound()
                    print("result not found")
                    return
            }
            
            let responses = root.responses
            var results = [GoogleVisionResults]()
            
            for label in responses{
                let labelAnnotations = label.labelAnnotations
                for item in labelAnnotations{
                    
                    let googleVisionResults = GoogleVisionResults(description: item.description, score: String(item.score))
                    results.append(googleVisionResults)
                }
            }
            
            self.delegate?.resultFound(googleVisionResult: results)
        }
        
        task.resume()
    }
}

