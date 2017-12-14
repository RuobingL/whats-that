//
//  WikipediaAPIManager.swift
//  whats-that-RuobingL
//
//  Created by Ruobing Lyu on 12/12/17.
//  Copyright © 2017 Ruobing Lyu. All rights reserved.
//

import Foundation
import UIKit

protocol WikipediaResultDelegate{
    func wikipediaResultFound(wikipediaResults: WikipediaResults)
    func wikipediaResultNotFound()
}

class WikipediaManager {
    
    var delegate:WikipediaResultDelegate?
    
    func fetchWikipediaResults(label: String){
        var wikipediaResults = WikipediaResults(title: "", extract: "")
        var titleResult = ""
        var detailResult = ""
        var urlComponents = URLComponents(string: "https://en.wikipedia.org/w/api.php?")!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "prop", value: "extracts"),
            URLQueryItem(name: "exintro", value: ""),
            URLQueryItem(name: "explaintext", value: ""),
            URLQueryItem(name: "titles", value: "\(label)"),
        ]
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            //check for valid response with 200 (success)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                self.delegate?.wikipediaResultNotFound()
                print("200")
                return
            }
            
            guard let data = data, let responses = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] ?? [String:Any]() else {
                self.delegate?.wikipediaResultNotFound()
                print("1")
                return
            }
            
            guard let responseJsonObject = responses["query"] as? [String:Any], let pageJsonObject = responseJsonObject["pages"] as? [String:Any] else {
                self.delegate?.wikipediaResultNotFound()
                print("2")
                return
            }
            
            var pageid = ""
            for item in pageJsonObject{
                pageid = item.key
            }
            
            guard let pageidJsonObject = pageJsonObject[pageid] as? [String:Any] else {
                self.delegate?.wikipediaResultNotFound()
                print("3")
                return
            }
            
            for item in pageidJsonObject{
                if(item.key == "title"){
                    titleResult = item.value as! String
                }
                if(item.key == "extract"){
                    detailResult = item.value as! String
                }
            }
            
            print("4", detailResult)
            let result = WikipediaResults(title: titleResult, extract: detailResult)
            self.delegate?.wikipediaResultFound(wikipediaResults: result)
        }
        
        task.resume()
    }
}
