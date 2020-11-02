//
//  TeacherCoordinator.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
import UIKit

class TeacherCoordinator: Coordinator {
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
            vc = TeacherMainScreenVC()
        }
        vc.coordinator = self
        navigationController.delegate = self as? UINavigationControllerDelegate
        if pop { navigationController.popViewController(animated: true) }
        navigationController.pushViewController(vc as! UIViewController, animated: true)
        currentScreen = screenName
    }
    
    
    private init(){}
    private static let instance = TeacherCoordinator()
    public static func getInstance() -> TeacherCoordinator{
        return .instance
    }
    
    
    
    
}
