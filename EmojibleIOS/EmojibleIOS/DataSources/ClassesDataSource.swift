//
//  ClassesDataSource.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
import Firebase

class ClassesDataSource{
    let database = Firestore.firestore()
    var snapshotListener:ListenerRegistration!
    
    private init(){
    }
    private static let instance = ClassesDataSource()
    public static func getInstance() -> ClassesDataSource{
        return .instance
    }
    
    public func signUpToClass(classCode:String, classPassword:String, completion: @escaping (String?) -> Void){
        
    }
    
}
