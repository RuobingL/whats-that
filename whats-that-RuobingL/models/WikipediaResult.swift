//
//  WikipediaResult.swift
//  whats-that-RuobingL
//
//  Created by Ruobing Lyu on 12/12/17.
//  Copyright © 2017 Ruobing Lyu. All rights reserved.
//

import Foundation

class WikipediaResults: NSObject {
    
    let title: String
    let extract: String
    
    let titleKey = "title"
    let extractKey = "extract"
    
    init(title:String, extract: String) {
        self.title = title
        self.extract = extract
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: titleKey) as? String ?? ""
        extract = aDecoder.decodeObject(forKey: extractKey) as? String ?? ""
    }
}

extension WikipediaResults: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: titleKey)
        aCoder.encode(extract, forKey: extractKey)
    }
}
