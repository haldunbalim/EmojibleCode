//
//  User.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
class UserModel{
    
    enum UserType:String{
        case Teacher = "Teacher"
        case Student = "Student"
    }
    
    var uid:String
    var userType: UserType
    var email:String
    var name:String
    var surname:String
    var birthDate:Date
    
    init(uid:String, userType: String, email:String, password:String, name:String, surname:String, birthDate:Date) {
        self.uid = uid
        self.userType = UserType(rawValue: userType)!
        self.email = email
        self.name = name
        self.surname = surname
        self.birthDate = birthDate
    }
    
    var dictionary: [String:Any]{
        return [
            "uid":uid,
            "userType":userType.rawValue,
            "email":email,
            "name":name,
            "surname":surname,
            "birthDate":birthDate,
        ]
    }
    
    init (dictionary: [String:Any]) {
        uid = dictionary["uid"] as! String
        email = dictionary["email"] as! String
        name = dictionary["name"] as! String
        surname = dictionary["surname"] as! String
        userType = UserType(rawValue: dictionary["userType"] as! String)!
        birthDate = CustomDateFormatter.getInstance().getDateFromString(from:  dictionary["birthDate"] as! String)
        surname = dictionary["birthDate"] as! String
    }
    
    
}
