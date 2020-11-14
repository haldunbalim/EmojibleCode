//
//  TutorialsCoordinator.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 11.11.2020.
//

import Foundation
import UIKit

class TutorialsCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var navigationController:UINavigationController
    var storyboard = UIStoryboard.init(name: "StudentApp", bundle: Bundle.main)
    

    enum screenEnum{
        case TutorialScreen
    }
    
    var currentScreen: screenEnum = .TutorialScreen

    
    func start() {
        openScreen(screenName: currentScreen)
    }
    
    func openScreen(screenName: screenEnum, pop: Bool = false){
        var vc: Coordinated!
        
        switch screenName{
        case .TutorialScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "TutorialScreenVC") as? TutorialScreenVC
        }
        
        vc.coordinator = self
        navigationController.delegate = self as? UINavigationControllerDelegate
        if pop { navigationController.popViewController(animated: true) }
        navigationController.pushViewController(vc as! UIViewController, animated: true)
        currentScreen = screenName
    }
    
    
    private init(){
        navigationController = self.storyboard.instantiateViewController(withIdentifier: "TutorialsNavController") as! UINavigationController
    }
    
    private static var instance: TutorialsCoordinator!
    public static func getInstance() -> TutorialsCoordinator{
        if(instance == nil){
            instance = TutorialsCoordinator()
        }
        return .instance
    }
    
}
