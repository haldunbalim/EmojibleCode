//
//  ClassModel.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
class ClassModel{
    var id:String
    var members:[String]
    
    init(id:String,members:[String]) {
        self.id = id
        self.members = members
    }
}
