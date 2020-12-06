//
//  EmojiAssignmentCoordinator.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 11.11.2020.
//

import Foundation
import UIKit

class EmojiAssignmentCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var navigationController:UINavigationController
    var storyboard = UIStoryboard.init(name: "StudentApp", bundle: Bundle.main)
    

    enum screenEnum{
        case AssignmentScreen
    }
    
    var currentScreen: screenEnum = .AssignmentScreen

    
    func start() {
        openScreen(screenName: currentScreen)
    }
    
    func openScreen(screenName: screenEnum, pop: Bool = false){
        var vc: Coordinated!
        
        switch screenName{
        
        case .AssignmentScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "AssignmentScreenVC") as? AssignmentScreenVC
        }
        
        vc.coordinator = self
        navigationController.delegate = self as? UINavigationControllerDelegate
        if pop { navigationController.popViewController(animated: true) }
        navigationController.pushViewController(vc as! UIViewController, animated: true)
        currentScreen = screenName
    }
    
    
    private init(){
        navigationController = self.storyboard.instantiateViewController(withIdentifier: "AssignmentsNavController") as! UINavigationController
        self.navigationController.navigationBar.isHidden = true
    }
    private static var instance: EmojiAssignmentCoordinator!
    public static func getInstance() -> EmojiAssignmentCoordinator{
        if(instance == nil){
            instance = EmojiAssignmentCoordinator()
        }
        return .instance
    }
    
}

