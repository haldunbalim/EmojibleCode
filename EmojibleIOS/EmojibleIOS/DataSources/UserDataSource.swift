//
//  UserDataSource.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
import Firebase

class UserDataSource{
    let database = Firestore.firestore()
    var snapshotListener:ListenerRegistration?
    let notificationCenter = NotificationCenter.default
    
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
    
    func startObservingUserModel(){
        guard let currentUser = AuthenticationManager.getInstance().currentUser else { return }
        let userDocRef = database.collection("Users").document(currentUser.uid)
        snapshotListener = userDocRef.addSnapshotListener{ [unowned self] documentSnapshot, error in
            guard let document = documentSnapshot else { return }
            guard let dict = document.data() else { return }
            notificationCenter.post(name: .userModelChanged, object: nil, userInfo:["userModel":UserFactory.getInstance().create(dict: dict)])
        }
    }
    
    func stopObservingUserModel(){
        guard let snapshotListener = snapshotListener else { return }
        snapshotListener.remove()        
    }
    
    public func writeUserData(user:UserModel){
        guard let currentUser = AuthenticationManager.getInstance().currentUser else { return }
        let uid = currentUser.uid
        self.database.collection("Users").document(uid).setData(user.dictionary)
    }
    
    public func editUserData(newData: [String:Any]){
        guard let currentUser = AuthenticationManager.getInstance().currentUser else { return }
        let uid = currentUser.uid
        self.database.collection("Users").document(uid).updateData(newData)
    }
    
    public func resetUserClassId(classId: String){
        database.collection("Users").whereField("classId", isEqualTo: classId).getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    self.database.collection("Users").document(document.documentID).updateData(["classId" : ""])
                }
            }
        }
    }
}
