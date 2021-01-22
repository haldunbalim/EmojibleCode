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
        openScreen(screenName: .ProgramScreen)
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
        navigationController.pushViewController(vc as! UIViewController, animated: true)
        currentScreen = screenName
    }
    
    func pop(animated: Bool = true){
        navigationController.popViewController(animated: animated)
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
}
