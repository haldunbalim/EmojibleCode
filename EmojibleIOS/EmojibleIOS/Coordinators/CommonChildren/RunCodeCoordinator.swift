//
//  RunCodeCoordinator.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 5.12.2020.
//

import Foundation
import UIKit

class RunCodeCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var navigationController = UINavigationController()
    var runScreen:RunScreenVC!
    
    var runningCode:String?
    
    func start() {
        runScreen = RunScreenVC()
        runScreen.coordinator = self
        navigationController.pushViewController(runScreen, animated: true)
    }
    
    private init(){
        self.navigationController.navigationBar.isHidden = true
    }
    
    private static var instance: RunCodeCoordinator!
    public static func getInstance() -> RunCodeCoordinator{
        if(instance == nil){
            instance = RunCodeCoordinator()
        }
        return .instance
    }
}
