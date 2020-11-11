//
//  StudentCoordinator.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
import UIKit

class StudentCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var navigationController = UINavigationController()
    var storyboard = UIStoryboard.init(name: "StudentApp", bundle: Bundle.main)
    

    enum screenEnum{
        case MainScreen
        case CodingScreen
        case TutorialScreen
        case AssignmentScreen
    }
    
    var currentScreen: screenEnum = .MainScreen

    
    func start() {
        openScreen(screenName: currentScreen)
    }
    
    func openScreen(screenName: screenEnum, pop: Bool = false){
        var vc: Coordinated!
        
        switch screenName{
        case .MainScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "StudentMainScreenVC") as? StudentMainScreenVC
        case .CodingScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "CodingScreenVC") as? CodingScreenVC
        case .TutorialScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "TutorialScreenVC") as? TutorialScreenVC
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
        navigationController = self.storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
    }
    private static let instance = StudentCoordinator()
    public static func getInstance() -> StudentCoordinator{
        return .instance
    }
    
}
