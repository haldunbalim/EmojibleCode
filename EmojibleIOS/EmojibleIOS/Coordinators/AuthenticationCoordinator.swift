//
//  AuthenticationCoordinator.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
import UIKit

class AuthenticationCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var storyboard = UIStoryboard.init(name: "AuthenticationStoryboard", bundle: Bundle.main)
    var navigationController: UINavigationController
    var registeringUserType:String?
    
    enum screenEnum{
        case Login
        case Register
        case ForgetPassword
    }
    
    var currentScreen: screenEnum = .Login

    func start() {
        openScreen(screenName: currentScreen)
    }
    
    func reset(){
        for _ in 0...navigationController.viewControllers.count{
            pop()
        }
        openScreen(screenName: .Login)
    }
    
    func openScreen(screenName: screenEnum, pop: Bool = false){
        var vc: Coordinated!
        
        switch screenName{
        case .Login:
            vc = self.storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        case .Register:
            vc = self.storyboard.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC
        case .ForgetPassword:
            vc = self.storyboard.instantiateViewController(withIdentifier: "ForgetPasswordVC") as? ForgetPasswordVC
        }
        
        vc.coordinator = self
        if pop { navigationController.popViewController(animated: true) }
        navigationController.pushViewController(vc as! UIViewController, animated: false)
        currentScreen = screenName
    }
    
    func pop(){
        navigationController.popViewController(animated: true)
    }
    
    private init(){
        navigationController = self.storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        self.navigationController.navigationBar.isHidden = true
    }
    
    private static var instance: AuthenticationCoordinator!
    public static func getInstance() -> AuthenticationCoordinator{
        if instance == nil{
            instance = AuthenticationCoordinator()
        }
        return .instance
    }
}
