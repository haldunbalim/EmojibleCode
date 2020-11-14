//
//  SettingsCoordinator.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 11.11.2020.
//

import Foundation
import UIKit

class SettingsCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var navigationController:UINavigationController
    var storyboard = UIStoryboard.init(name: "StudentApp", bundle: Bundle.main)
    

    enum screenEnum{
       case SettingsScreen
    }
    
    var currentScreen: screenEnum = .SettingsScreen

    
    func start() {
        openScreen(screenName: currentScreen)
    }
    
    func openScreen(screenName: screenEnum, pop: Bool = false){
        var vc: Coordinated!
        
        switch screenName{
        case .SettingsScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "SettingsScreenVC") as? SettingsScreenVC
        }
        
        vc.coordinator = self
        navigationController.delegate = self as? UINavigationControllerDelegate
        if pop { navigationController.popViewController(animated: true) }
        navigationController.pushViewController(vc as! UIViewController, animated: true)
        currentScreen = screenName
    }
    
    
    private init(){
        navigationController = self.storyboard.instantiateViewController(withIdentifier: "SettingsNavController") as! UINavigationController
    }
    private static var instance: SettingsCoordinator!
    public static func getInstance() -> SettingsCoordinator{
        if(instance == nil){
            instance = SettingsCoordinator()
        }
        return .instance
    }
    
}
