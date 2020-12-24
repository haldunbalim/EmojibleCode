//
//  ClassModel.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
class ClassModel: Equatable{
    var id:String
    var teacherId:String
    var className:String
    var password:String
    
    init(id:String, teacherId:String, className:String, password:String) {
        self.id = id
        self.teacherId = teacherId
        self.className = className
        self.password = password
    }
    
    var dictionary: [String:Any]{
        return [
            "id":id,
            "teacherId":teacherId,
            "className": className,
            "password":password,
        ]
    }
    
    init (dictionary: [String:Any]) {
        id = dictionary["id"] as! String
        teacherId = dictionary["teacherId"] as! String
        className = dictionary["className"] as! String
        password = dictionary["password"] as! String
    }
    
    static func == (lhs: ClassModel, rhs: ClassModel) -> Bool {
        return lhs.id == rhs.id && lhs.teacherId == rhs.teacherId
    }
}
