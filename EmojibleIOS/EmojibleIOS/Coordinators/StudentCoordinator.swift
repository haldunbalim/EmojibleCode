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

    enum screenEnum{
        case MainScreen
    }
    
    var currentScreen: screenEnum = .MainScreen

    
    func start() {
        openScreen(screenName: currentScreen)
    }
    
    func openScreen(screenName: screenEnum, pop: Bool = false){
        var vc: Coordinated!
        
        switch screenName{
        case .MainScreen:
            vc = StudentMainScreenVC()
        }
        vc.coordinator = self
        navigationController.delegate = self as? UINavigationControllerDelegate
        if pop { navigationController.popViewController(animated: true) }
        navigationController.pushViewController(vc as! UIViewController, animated: true)
        currentScreen = screenName
    }
    
    
    private init(){}
    private static let instance = StudentCoordinator()
    public static func getInstance() -> StudentCoordinator{
        return .instance
    }
    
}
