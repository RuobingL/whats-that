//
//  SearchTimelineViewController.swift
//  whats-that-RuobingL
//
//  Created by Ruobing Lyu on 12/12/17.
//  Copyright © 2017 Ruobing Lyu. All rights reserved.
//

import UIKit
import TwitterKit

class SearchTimelineViewController: TWTRTimelineViewController {
    
    var  query = "query"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = TWTRSearchTimelineDataSource(searchQuery: query, apiClient: TWTRAPIClient())
    }
}
