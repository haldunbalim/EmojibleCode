//
//  TeacherModel.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
class TeacherModel: UserModel{
    var classIds: [String]
    
    init(email:String, name:String, surname:String, birthDate:Date, classIds:[String] = []) {
        self.classIds = classIds
        super.init(email:email, name:name, surname:surname, birthDate: birthDate)
        
    }
    
    override init(dictionary: [String:Any]) {
        classIds = dictionary["classIds"] as! [String]
        super.init(dictionary: dictionary)
    }
    
    override var dictionary: [String : Any]{
        var dict = super.dictionary
        dict["classIds"] = classIds
        dict["userType"] = "Teacher"
        return dict
    }
}
