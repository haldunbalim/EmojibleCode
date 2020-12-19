//
//  User.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
class UserModel{
    
    var email:String
    var name:String
    var surname:String
    var birthDate:Date
    
    init(email:String, name:String, surname:String, birthDate:Date) {
        self.email = email
        self.name = name
        self.surname = surname
        self.birthDate = birthDate
    }
    
    var dictionary: [String:Any]{
        return [
            "email":email,
            "name":name,
            "surname":surname,
            "birthDate":CustomDateFormatter.getInstance().getStringFromDate(from:birthDate),
        ]
    }
    
    init (dictionary: [String:Any]) {
        email = dictionary["email"] as! String
        name = dictionary["name"] as! String
        surname = dictionary["surname"] as! String
        birthDate = CustomDateFormatter.getInstance().getDateFromString(from:  dictionary["birthDate"] as! String)
    }
    
    
}
