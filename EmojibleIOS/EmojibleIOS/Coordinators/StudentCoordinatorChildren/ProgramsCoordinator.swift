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
    var storyboard = UIStoryboard.init(name: "MainApp", bundle: Bundle.main)
    
    var programModel: CodeModel?
    var runningCode: String?

    enum screenEnum{
        case ProgramScreen
        case SavedCodeScreen
        case CodingScreen
    }
    
    var currentScreen: screenEnum = .ProgramScreen

    func start() {
        if AuthenticationManager.getInstance().currentUser != nil{
            openScreen(screenName: .ProgramScreen)
        }else{
            openScreen(screenName: .CodingScreen)
        }
    }
    
    func openScreen(screenName: screenEnum, pop: Bool = false){
        var vc: Coordinated!
        
        switch screenName{
        
        case .ProgramScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "ProgramScreenVC") as? ProgramScreenVC
        case .CodingScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "CodingScreenVC") as? CodingScreenVC
        case .SavedCodeScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "SavedProgramCodeScreenVC") as? SavedProgramCodeScreenVC
        }
        
        vc.coordinator = self
        navigationController.delegate = self as? UINavigationControllerDelegate
        if pop { navigationController.popViewController(animated: true) }
        if navigationController.viewControllers.count > 0 && navigationController.viewControllers[0] is CodingScreenVC {
            navigationController.viewControllers[0] = vc as! UIViewController
        }
        else {
            navigationController.pushViewController(vc as! UIViewController, animated: true)
        }
        currentScreen = screenName
    }
    
    func pop(){
        navigationController.popViewController(animated: true)
    }
    
    private init(){
        navigationController = self.storyboard.instantiateViewController(withIdentifier: "ProgramsNavController") as! UINavigationController
        self.navigationController.navigationBar.isHidden = true
    }
    
    private static var instance: ProgramsCoordinator!
    public static func getInstance() -> ProgramsCoordinator{
        if(instance == nil){
            instance = ProgramsCoordinator()
        }
        return .instance
    }
    
    func isRootViewController(screen: UIViewController) -> Bool{
        return self.navigationController.viewControllers[0] == screen
    }
    
}
