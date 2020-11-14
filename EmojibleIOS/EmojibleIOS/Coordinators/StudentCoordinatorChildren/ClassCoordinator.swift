//
//  ClassCoordinator.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 11.11.2020.
//

import Foundation
import UIKit

class ClassCoordinator: Coordinator, UserModelListener {
    var parentCoordinator: Coordinator?
    var navigationController = UINavigationController()
    var storyboard = UIStoryboard.init(name: "StudentApp", bundle: Bundle.main)
    

    enum screenEnum{
        case ClassScreen
        case SignUp
    }
    
    var currentScreen: screenEnum = .ClassScreen

    
    func start() {
        UserDataSource.getInstance().listenForUserModelChanges(listener: self)
        openScreen(screenName: currentScreen)
    }
    
    func notify(userModel: UserModel) {
            guard let userModel = userModel as? StudentModel else { return }
        if userModel.classId == nil{
            openScreen(screenName: .SignUp,pop: false)
        }else{
            openScreen(screenName: .ClassScreen,pop: false)
        }
    }
    
    func openScreen(screenName: screenEnum, pop: Bool = false){
        var vc: Coordinated!
        
        switch screenName{
        case .ClassScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "ClassScreenVC") as? ClassScreenVC
        case .SignUp:
            vc = self.storyboard.instantiateViewController(withIdentifier: "ClassSignUpVC") as? ClassSignUpVC
        }
        
        vc.coordinator = self
        navigationController.delegate = self as? UINavigationControllerDelegate
        if pop { navigationController.popViewController(animated: true) }
        if self.navigationController.viewControllers.count > 0{
            self.navigationController.viewControllers.remove(at: 0)
        }
        navigationController.pushViewController(vc as! UIViewController, animated: true)
        currentScreen = screenName
    }
    
    
    private init(){
        navigationController = self.storyboard.instantiateViewController(withIdentifier: "ClassNavController") as! UINavigationController
    }
    private static var instance: ClassCoordinator!
    public static func getInstance() -> ClassCoordinator{
        if(instance == nil){
            instance = ClassCoordinator()
        }
        return .instance
    }
    
}

