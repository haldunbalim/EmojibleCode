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
    var commonCoordinator = CommonCoordinator.getInstance()
    let notificationCenter = NotificationCenter.default
    
    
    var window: UIWindow
    var currentCoordinator: Coordinator?
    
    
    enum coordinatorEnum: Int{
        case Common
        case Student
        case Teacher
        case Authentication
    }
    
    init(window: UIWindow){
        self.window = window
        authenticationCoordinator.parentCoordinator = self
        commonCoordinator.parentCoordinator = self
        studentCoordinator.parentCoordinator = self
        teacherCoordinator.parentCoordinator = self
        notificationCenter.addObserver(self, selector: #selector(notify), name: .authStateChanged, object: nil)
        AuthenticationManager.getInstance().startListeningForAuthStateChanges()
    }
    
    @objc func notify() {
        start()
    }
    
    func start(){
        if AuthenticationManager.getInstance().isUserLoggedIn(){
            UserDataSource.getInstance().getCurrentUserInfo(){ userModel in
                guard let userModel = userModel else {return}
                if userModel is StudentModel {
                    self.studentCoordinator.start()
                    self.window.rootViewController = self.studentCoordinator.tabBarController
                    self.currentCoordinator = self.studentCoordinator
                    self.window.makeKeyAndVisible()
                    
                }else{
                    self.teacherCoordinator.start()
                    self.window.rootViewController = self.teacherCoordinator.tabBarController
                    self.currentCoordinator = self.teacherCoordinator
                    self.window.makeKeyAndVisible()
                }
                UserDataSource.getInstance().startObservingUserModel()
            }
        }else{
            self.commonCoordinator.start()
            self.window.rootViewController = self.commonCoordinator.tabBarController
            self.currentCoordinator = self.commonCoordinator
            self.window.makeKeyAndVisible()
        }
    }
}
