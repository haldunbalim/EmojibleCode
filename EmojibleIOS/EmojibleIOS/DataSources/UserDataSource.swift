//
//  UserDataSource.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
import Firebase

class UserDataSource{
    var currentUser: UserModel?
    let database = Firestore.firestore()
    var snapshotListener:ListenerRegistration!
    var listeners: Array<UserModelListener> = []
    
    private init(){
    }
    private static let instance = UserDataSource()
    public static func getInstance() -> UserDataSource{
        return .instance
    }
    
    func getCurrentUserInfo(completion: @escaping (UserModel?) -> Void){
        if let currentUser = AuthenticationManager.getInstance().currentUser{
            let userDocRef = database.collection("Users").document(currentUser.uid)
            userDocRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    guard let dict = document.data() else { return }
                    let userInfo = UserFactory.getInstance().create(dict: dict)
                    completion(userInfo)
                }else{
                    completion(nil)
                }
            }
        }else{
            completion(nil)
        }
    }
    
    func listenForUserModelChanges <T:UserModelListener> (listener: T){
        listeners.append(listener)
    }
    
    func startObservingUserModel(){
        let currentUser = AuthenticationManager.getInstance().currentUser
        let userDocRef = database.collection("Users").document(currentUser!.uid)
        var snapshotListener = userDocRef.addSnapshotListener{ [unowned self] documentSnapshot, error in
            guard let document = documentSnapshot else { return }
            guard let dict = document.data() else { return }
            for listener in self.listeners{
                listener.notify(userModel: UserFactory.getInstance().create(dict: dict))
            }
        }
    }
    
    func stopObservingUserModel(){
        snapshotListener.remove()
        listeners = []
        
    }
    
    public func writeUserData(user:UserModel){
        let uid = AuthenticationManager.getInstance().currentUser!.uid
        self.database.collection("Users").document(uid).setData(user.dictionary)
    }
    
}
