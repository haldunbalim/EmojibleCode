//
//  User.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
class User{
    
    enum UserType{
        case Teacher
        case Student
    }
    
    var userType: UserType
    
    init(userType: UserType) {
        self.userType = userType
    }
}
