//
//  StudentModel.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
class StudentModel:UserModel{
    var classId: String?
    
    init(email:String, name:String, surname:String, birthDate:Date, classId:String? = nil) {
        self.classId = classId == nil ? "" : classId
        super.init(email:email, name:name, surname:surname, birthDate: birthDate)
    }
    
    //to document
    
    override init(dictionary: [String:Any]) {
        classId = dictionary["classId"] as? String ?? ""
        super.init(dictionary: dictionary)
    }
    
    override var dictionary: [String : Any]{
        var dict = super.dictionary
        dict["classId"] = classId
        dict["userType"] = "Student"
        return dict
    }
}
