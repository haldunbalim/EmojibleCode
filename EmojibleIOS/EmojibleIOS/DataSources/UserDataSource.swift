//
//  UserDataSource.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation

class UserDataSource{
    var currentUser: User?
    
    private init(){}
    private static let instance = UserDataSource()
    public static func getInstance() -> UserDataSource{
        return .instance
    }
    
    // TODO: Not Implemented Yet
    public func getCurrentUserInfo(){
        currentUser = User(userType: .Student)
    }
    
}
