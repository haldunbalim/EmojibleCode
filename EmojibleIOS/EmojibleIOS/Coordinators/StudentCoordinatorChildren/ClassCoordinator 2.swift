//
//  ClassCoordinator.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 11.11.2020.
//

import Foundation
import UIKit

class ClassCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var tutorialTitle: String?
    var tutorialCode: String?
    
    var navigationController:UINavigationController
    var storyboard = UIStoryboard.init(name: "MainApp", bundle: Bundle.main)
    let notificationCenter = NotificationCenter.default
    

    enum screenEnum{
        case ClassScreen
        case SignUp
        case TutorialCodeScreen
    }
    
    var currentScreen: screenEnum = .ClassScreen
    
    func start() {
        notificationCenter.addObserver(self, selector: #selector(notify(_:)), name: .userModelChanged, object: nil)
    }
    
    @objc func notify(_ notification: NSNotification) {
        guard let notificationArgs = notification.userInfo else { return }
        guard let userModel = notificationArgs["userModel"] as? StudentModel else { return }
        if userModel.classId == ""{
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
        case .TutorialCodeScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "ClassCodeScreenVC") as? ClassCodeScreenVC
        }
        
        vc.coordinator = self
        navigationController.delegate = self as? UINavigationControllerDelegate
        if pop { navigationController.popViewController(animated: true) }
        navigationController.pushViewController(vc as! UIViewController, animated: true)
        currentScreen = screenName
    }
    
    func pop(){
        navigationController.popViewController(animated: true)
    }
    
    private init(){
        navigationController = self.storyboard.instantiateViewController(withIdentifier: "ClassNavController") as! UINavigationController
        self.navigationController.navigationBar.isHidden = true
    }
    
    private static var instance: ClassCoordinator!
    public static func getInstance() -> ClassCoordinator{
        if(instance == nil){
            instance = ClassCoordinator()
        }
        return .instance
    }
}

