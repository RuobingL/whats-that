//
//  GoogleVisionResults.swift
//  whats-that-RuobingL
//
//  Created by Ruobing Lyu on 12/12/17.
//  Copyright © 2017 Ruobing Lyu. All rights reserved.
//

import Foundation

struct GoogleVisionResults: Decodable {
    let description: String
    let score: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case score
    }
}
