//
//  AuthenticationManager.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
class AuthenticationManager {
    
    private init(){}
    private static let instance = AuthenticationManager()
    public static func getInstance() -> AuthenticationManager{
        return .instance
    }
    
    // TODO: Not Implemented Yet
    public func isUserLoggedIn() -> Bool{
        return false
    }
    
}
