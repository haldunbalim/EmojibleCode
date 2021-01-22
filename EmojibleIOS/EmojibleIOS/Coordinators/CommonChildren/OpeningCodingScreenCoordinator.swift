//
//  OpeningCodingScreen.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 22.12.2020.
//

import Foundation
import UIKit

class OpeningCodingScreenCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var navigationController:UINavigationController
    var storyboard = UIStoryboard.init(name: "MainApp", bundle: Bundle.main)
    

    enum screenEnum{
        case CodingScreen
    }
    
    var currentScreen: screenEnum = .CodingScreen
    
    func start() {
        openScreen(screenName: currentScreen)
    }
    
    func openScreen(screenName: screenEnum, pop: Bool = false){
        var vc: Coordinated!
        
        switch screenName{
        case .CodingScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "OpeningCodingScreen") as? OpeningCodingScreen
        }
        
        vc.coordinator = self
        navigationController.delegate = self as? UINavigationControllerDelegate
        if pop { navigationController.popViewController(animated: true) }
        navigationController.pushViewController(vc as! UIViewController, animated: true)
        currentScreen = screenName
    }
    
    private init(){
        navigationController = self.storyboard.instantiateViewController(withIdentifier: "OpeningCodeScreenNavController") as! UINavigationController
        self.navigationController.navigationBar.isHidden = true
    }
    
    private static var instance: OpeningCodingScreenCoordinator!
    public static func getInstance() -> OpeningCodingScreenCoordinator{
        if(instance == nil){
            instance = OpeningCodingScreenCoordinator()
        }
        return .instance
    }
    
}
