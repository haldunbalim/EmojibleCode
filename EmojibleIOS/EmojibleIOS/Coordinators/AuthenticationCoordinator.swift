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
    
    enum screenEnum{
        case Login
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
        }
        vc.coordinator = self
        if pop { navigationController.popViewController(animated: true) }
        navigationController.present(vc as! UIViewController, animated: false, completion: nil)
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