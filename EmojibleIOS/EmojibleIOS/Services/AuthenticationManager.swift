//
//  AuthenticationManager.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
import Firebase


class AuthenticationManager {
    let firebaseAuth = Auth.auth()
    var currentUser:User?
    let notificationCenter = NotificationCenter.default

    private init(){
    }
    
    func startListeningForAuthStateChanges(){
        _ = Auth.auth().addStateDidChangeListener { [unowned self] (auth, user) in
            currentUser = Auth.auth().currentUser
            notificationCenter.post(name: .authStateChanged, object: nil)
        }
    }
    
    private static var instance: AuthenticationManager!
    public static func getInstance() -> AuthenticationManager{
        if instance == nil{
            instance = AuthenticationManager()
        }
        return .instance
    }
    
    // TODO: Not Implemented Yet
    public func isUserLoggedIn() -> Bool{
        return firebaseAuth.currentUser != nil
    }
    
}


// email functions
extension AuthenticationManager{
    
    func checkIfUserWithEmailExists(email: String, completion: @escaping (Any?) -> Void){
        Auth.auth().fetchSignInMethods(forEmail: email){ result, error in
            if let error = error {
                completion(error)
            }else{
                completion(result)
            }
        }
    }
    
    
    func createUserWithEmailAndPassword(email: String, password: String, completion: @escaping ((String?) -> Void)){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error{
                completion(error.localizedDescription)
            }else{
                completion(nil)
            }
        }
    }
    
    
    func signInWithEmailAndPassword(email:String, password:String, completion: @escaping ((String?) -> Void)){
        Auth.auth().signIn(withEmail: email, password: password) {user, error in
            if let error = error {
                completion(error.localizedDescription)
            }else{
                completion(nil)
            }
        }
    }
    
    
}

    
// utility functions
extension AuthenticationManager{
    
    func signOut() -> String? {
        do {
            // UserDatabaseManager.singleton.currentUser = nil
            try Auth.auth().signOut()
            // LoginManager().logOut()
            return nil
        } catch let signOutError as NSError {
            return "Error signing out: \(signOutError)"
        }
    }
    
    func resetPassword(email:String, completion: @escaping ((String?) -> Void)) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(error.localizedDescription)
            }else{
                completion(nil)
            }
        }
    }
   /*
     // May not be needed
    func linkFacebookToAccount(completion: @escaping ((String?) -> Void)){
        if !isLoggedInWithFBAuth{
            completion("Hesabınız Facebook ile bağlanmış durumda")
        }else if let user = Auth.auth().currentUser {
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            user.link(with: credential) { (authResult, error) in
                if let error = error {
                    completion(error.localizedDescription)
                }else{
                    completion(nil)
                }
            }
        }
    }
    
    func linkPasswordToAccount(password:String, completion: @escaping ((String?) -> Void)){
        if let user = Auth.auth().currentUser {
            let credential = EmailAuthProvider.credential(withEmail:UserDatabaseManager.singleton.currentUser!.email, password: password)
            user.link(with: credential) { (authResult, error) in
                if let error = error {
                    completion(error.localizedDescription)
                }else{
                    completion(nil)
                }
            }
        }
    }
    */
}
