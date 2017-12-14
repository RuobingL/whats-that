import Foundation

class Persistance {
    static let sharedInstance = Persistance()
    
    let resultsKey = "results"
    
    func fetchWikipediaResults() -> [WikipediaResults] {
        let userDefaults = UserDefaults.standard
        
        let data = userDefaults.object(forKey: resultsKey) as? Data
        
        if let data = data {
            //data is not nil, so use it
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [WikipediaResults] ?? [WikipediaResults]()
        }
        else {
            //data is nil
            return [WikipediaResults]()
        }
    }
    
    func saveWikipediaResults(_ result: WikipediaResults) {
        let userDefaults = UserDefaults.standard
        
        var results = fetchWikipediaResults()
        results.append(result)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: results)
        
        userDefaults.set(data, forKey: resultsKey)
    }
}

