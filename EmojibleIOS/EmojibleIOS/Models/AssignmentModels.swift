//
//  Assignment.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import Foundation
enum ValueType{
    case Integer
    case Float
    case Boolean
    case String
    case Voice
}
class AssignmentModel: Equatable, Hashable, CustomStringConvertible{
    
    var identifier:String
    private var value:Value
    
    init(identifier: String, value: Any) {
        self.identifier = identifier
        self.value = Value(value: value)
    }
    
    init(dictionary: [String:Any]) {
        self.identifier = dictionary["identifier"] as! String
        self.value = Value(value: dictionary["value"] as Any)
    }
    
    var dictionary: [String:Any]{
        return [
            "identifier":identifier,
            "value":value.value,
        ]
    }
    
    static func == (lhs: AssignmentModel, rhs: AssignmentModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    
    var description: String{
        return "\(identifier) 👉 \(value.description)"
    }
    
    func getValue() -> Any{
        return value.value
    }
    
    func setValue(value: Any){
        self.value = Value(value: value)
    }
    
    var type: ValueType{
        get{
            return self.value.type
        }
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
    }
}

class Value{
    var value:Any
    var type:ValueType
    
    init(value: Any) {
        self.value = value
        self.type = Value.getType(value: value)
    }
    
    private static func getType(value:Any) -> ValueType{
        if value is Int{
            return .Integer
        }else if value is Float{
            return .Float
        }else if value is Bool{
            return .Boolean
        }else{
            if (value as! String).contains(".m4a") && FileSystemManager.getInstance().fileExists(filename: (value as! String)){
                return .Voice
            }else{
                return .String
            }
        }
    }
    
    var description: String{
        switch self.type{
        case .Integer:
            return String(value as! Int)
        case .Float:
            return String(value as! Float)
        case .Boolean:
            return value as! Bool == true ? "👍":"👎"
        case .String:
            return value as! String
        case .Voice:
            return ""
        }
    }
}
