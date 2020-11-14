//
//  Assignment.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import Foundation

struct Assignment {
    var pair : String
    
    init(variable: String, value: String) {
        self.pair = "\(variable) 👈 \(value)"
    }
}
