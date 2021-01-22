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
    var runCodeCoordinator =  RunCodeCoordinator.getInstance()
    let notificationCenter = NotificationCenter.default
    
    
    
    var window: UIWindow
    var currentCoordinator: coordinatorEnum = .Common
    
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
        runCodeCoordinator.start()

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
                    self.window.makeKeyAndVisible()
                    self.currentCoordinator = .Student
                    
                }else{
                    self.teacherCoordinator.start()
                    self.window.rootViewController = self.teacherCoordinator.tabBarController
                    self.window.makeKeyAndVisible()
                    self.currentCoordinator = .Teacher
                }
                UserDataSource.getInstance().startObservingUserModel()
            }
        }else{
            self.commonCoordinator.start()
            self.window.rootViewController = self.commonCoordinator.tabBarController
            self.currentCoordinator = .Common
            self.window.makeKeyAndVisible()
        }
    }
    
    public static func getInstance()->AppCoordinator{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.appCoordinator!
    }
    
    
    public func runCode(code:String){
        runCodeCoordinator.runningCode = code
        self.window.rootViewController = runCodeCoordinator.navigationController
       
    }
    
    public func terminateCode(){
        switch self.currentCoordinator {
        case .Student:
            self.window.rootViewController = studentCoordinator.tabBarController
        case .Teacher:
            self.window.rootViewController = teacherCoordinator.tabBarController
        case .Common:
            self.window.rootViewController = commonCoordinator.tabBarController
        default:
            return
        }
    }
}
