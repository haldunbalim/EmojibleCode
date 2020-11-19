//
//  CreateNewCodeCoordinator.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 11.11.2020.
//

import Foundation
import UIKit

class ProgramsCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var storyboard = UIStoryboard.init(name: "StudentApp", bundle: Bundle.main)
    

    enum screenEnum{
        case ProgramScreen
        case CodingScreen
    }
    
    var currentScreen: screenEnum = .ProgramScreen

    
    func start() {
        openScreen(screenName: currentScreen)
    }
    
    func openScreen(screenName: screenEnum, pop: Bool = false){
        var vc: Coordinated!
        
        switch screenName{
        
        case .ProgramScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "ProgramScreenVC") as? ProgramScreenVC
        case .CodingScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "CodingScreenVC") as? CodingScreenVC
        }
        
        vc.coordinator = self
        navigationController.delegate = self as? UINavigationControllerDelegate
        if pop { navigationController.popViewController(animated: true) }
        navigationController.pushViewController(vc as! UIViewController, animated: true)
        currentScreen = screenName
    }
    
    
    private init(){
        navigationController = self.storyboard.instantiateViewController(withIdentifier: "NewCodeNavController") as! UINavigationController
    }
    private static var instance: ProgramsCoordinator!
    public static func getInstance() -> ProgramsCoordinator{
        if(instance == nil){
            instance = ProgramsCoordinator()
        }
        return .instance
    }
    
}
