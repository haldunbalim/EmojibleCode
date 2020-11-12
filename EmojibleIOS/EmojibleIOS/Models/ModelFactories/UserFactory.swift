//
//  UserFactory.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation

class UserFactory{
    
    func create(userType:String, email:String, name:String, surname:String, birthDate:Date, classIds:[String]=[], classId:String?=nil)->UserModel{
        if userType == "Teacher"{
            return TeacherModel(email: email, name: name, surname: surname, birthDate: birthDate,classIds: classIds)
        }else{
            return StudentModel(email:email, name:name, surname:surname, birthDate:birthDate, classId: classId)
        }
    }
    
    func create(dict: [String:Any]) -> UserModel{
        let userType = dict["userType"] as! String
        if userType == "Student"{
            return StudentModel(dictionary: dict)
        }else{
            return TeacherModel(dictionary: dict)
        }
    }
    
    private init(){}
    private static let instance = UserFactory()
    public static func getInstance() -> UserFactory{
        return .instance
    }
}
