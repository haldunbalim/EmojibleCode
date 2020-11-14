//
//  CodeModel.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import UIKit

class CodeModel {
    var name: String
    var code: String
    
    init(name:String, code:String) {
        self.name = name
        self.code = code
    }
    
    var dictionary: [String:Any]{
        return [
            "name":name,
            "code":code,
        ]
    }
    
    init (dictionary: [String:Any]) {
        name = dictionary["name"] as! String
        code = dictionary["code"] as! String
    }
    
}
