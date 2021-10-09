//
//  Model.swift
//  motivaily
//
//  Created by Alexandre DUARTE on 09/10/2021.
//

import Foundation

struct Quote {
    let text: String
    let createdAt: String
    
    var isEmpty: Bool {
        return text.isEmpty && createdAt.isEmpty
    }
    
    init() {
        self.text = ""
        self.createdAt = ""
    }
    
    init?(data: [String: Any]?) {
        guard let text = data?[Constants.QUOTE] as? String,
              let createdAt = data?[Constants.CREATED_AT] as? String else {
            return nil
        }
        
        self.text = text
        self.createdAt = createdAt
    }
}
