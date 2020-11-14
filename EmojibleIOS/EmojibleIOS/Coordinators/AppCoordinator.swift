//
//  AppCoordinator.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator{
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
        
        
        /*
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil{
                self.openAuthentication()
            }
        }
        */
        
    }
    
    
    func start(){
        
        if AuthenticationManager.getInstance().isUserLoggedIn(){
            UserDataSource.getInstance().getCurrentUserInfo()
            if UserDataSource.getInstance().currentUser!.userType == .Student{
                self.window.rootViewController = self.studentCoordinator.navigationController
                self.currentCoordinator = self.studentCoordinator
            }else{
                self.window.rootViewController = self.teacherCoordinator.navigationController
                self.currentCoordinator = self.teacherCoordinator
            }
        }else{
            self.window.rootViewController = self.authenticationCoordinator.navigationController
            self.currentCoordinator = self.authenticationCoordinator
        }
        
        self.currentCoordinator!.start()
        self.window.makeKeyAndVisible()
    }
    
}
