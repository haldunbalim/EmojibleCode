//
//  TeacherModel.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
class TeacherModel: UserModel{
    override init(email:String, name:String, surname:String, birthDate:Date) {
        super.init(email:email, name:name, surname:surname, birthDate: birthDate)
    }
    
    override init(dictionary: [String:Any]) {
        super.init(dictionary: dictionary)
    }
    
    override var dictionary: [String : Any]{
        var dict = super.dictionary
        dict["userType"] = "Teacher"
        return dict
    }
}
