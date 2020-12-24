//
//  Token.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 3.12.2020.
//

import Foundation
class Token: CustomStringConvertible{
    var type:TokenType
    var value:Any
    var lineNumber:Int
    
    init(type:String, value:Any, lineNumber:Int) {
        self.type = TokenType(rawValue: type)!
        self.value = value
        self.lineNumber = lineNumber
    }
    
    var description: String { return type.description}
}

