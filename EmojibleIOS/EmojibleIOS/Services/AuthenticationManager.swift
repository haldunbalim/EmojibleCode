//
//  AuthenticationManager.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class AuthenticationManager {
    let firebaseAuth = Auth.auth()
    var currentUser:User?
    var authStateListeners: [AuthStateListener] = []

    private init(){
        _ = Auth.auth().addStateDidChangeListener { [unowned self] (auth, user) in
            currentUser = Auth.auth().currentUser
            for listener in self.authStateListeners{
                listener.notify()
            }
        }
    }
    
    public func listenForAuthStateChanges(listener:AuthStateListener){
        authStateListeners.append(listener)
    }
    
    private static let instance = AuthenticationManager()
    public static func getInstance() -> AuthenticationManager{
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
        Auth.auth().signIn(withEmail: email, password: password) {[unowned self] user, error in
            if let error = error {
                completion(error.localizedDescription)
            }else{
                completion(nil)
            }
        }
    }
    
    
}
    
// facebook login functions
extension AuthenticationManager{
    
    
    func facebookSignIn(completion: @escaping ((String?) -> Void)){
        //also registers user if there is no user registered with that username
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        self.firebaseLogin(credential, completion: completion)
    }
    
    /*
    func createUserInfoInFromFacebook(completion: @escaping (Error?, UserInfo?) -> Void){
        if isLoggedInWithFBAuth{
            self.requestInfoFromFacebook(){ result in
                if let error = result as? NSError{
                    //handle error here or above
                    completion(error, nil)
                }else if let result = result as? [String: String]{
                    self.createUserInfoIfDoesNotExist(name: result["first_name"]!, surname: result["last_name"]!, authenticationType: .Facebook){ userInfo in
                        completion(nil, userInfo)
                    }
                }
            }
        }
    }
    */
    
    private func requestInfoFromFacebook(completion: @escaping (Any) -> Void){
        if(AccessToken.current != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start{ (connection, result, error)  in
                if let error = error{
                    completion(error)
                }else if let result = result{
                    completion(result)
                }
            }
        }
    }
    
    
    private func firebaseLogin(_ credential: AuthCredential, completion: @escaping ((String?) -> Void)){
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
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
