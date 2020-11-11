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
    var storyboard = UIStoryboard(name: "AuthenticationStoryboard", bundle: Bundle.main)
    var navigationController: UINavigationController
    
    enum screenEnum{
        case Login
        case Register
    }
    
    var currentScreen: screenEnum = .Login

    
    func start() {
        openScreen(screenName: currentScreen)
    }
    
    func openScreen(screenName: screenEnum, pop: Bool = false){
        var vc: Coordinated!
        
        switch screenName{
        case .Login:
            vc = self.storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        case .Register:
            vc = self.storyboard.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC
        }
        vc.coordinator = self
        if pop { navigationController.popViewController(animated: true) }
        navigationController.pushViewController(vc as! UIViewController, animated: false)
        currentScreen = screenName
    }
    
    private init(){
        navigationController = self.storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
    }
    
    private static let instance = AuthenticationCoordinator()
    public static func getInstance() -> AuthenticationCoordinator{
        return .instance
    }
    
    
}
