//
//  AppCoordinator.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator, AuthStateListener{
    var parentCoordinator: Coordinator? = nil
    
    var authenticationCoordinator = AuthenticationCoordinator.getInstance()
    var studentCoordinator = StudentCoordinator.getInstance()
    var teacherCoordinator = TeacherCoordinator.getInstance()
    
    var window: UIWindow
    var currentCoordinator: Coordinator?
    
    enum coordinatorEnum: Int{
        case Student
        case Teacher
        case Authentication
    }
    
    init(window: UIWindow){
        
        self.window = window
        
        authenticationCoordinator.parentCoordinator = self
        studentCoordinator.parentCoordinator = self
        teacherCoordinator.parentCoordinator = self
        AuthenticationManager.getInstance().listenForAuthStateChanges(listener: self)
    }
    
    func notify() {
        start()
    }
    
    func start(){
        
        if AuthenticationManager.getInstance().isUserLoggedIn(){
            UserDataSource.getInstance().getCurrentUserInfo(){ userModel in
                guard let userModel = userModel else {return}
                UserDataSource.getInstance().startObservingUserModel()
                if userModel is StudentModel {
                    self.window.rootViewController = self.studentCoordinator.tabBarController
                    self.currentCoordinator = self.studentCoordinator
                }else{
                    self.window.rootViewController = self.teacherCoordinator.navigationController
                    self.currentCoordinator = self.teacherCoordinator
                }
                self.currentCoordinator!.start()
                self.window.makeKeyAndVisible()
            }
        }else{
            self.window.rootViewController = self.authenticationCoordinator.navigationController
            self.currentCoordinator = self.authenticationCoordinator
            self.currentCoordinator!.start()
            self.window.makeKeyAndVisible()
        }
    }
    
}
