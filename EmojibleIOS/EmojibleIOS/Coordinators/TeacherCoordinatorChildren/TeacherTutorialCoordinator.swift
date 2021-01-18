//
//  TeacherTutorialCoordinator.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 12.12.2020.
//

import Foundation
import UIKit

class TeacherTutorialCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var storyboard = UIStoryboard.init(name: "MainApp", bundle: Bundle.main)
    
    var tutorialModel: CodeModel?
    var runningCode: String?

    enum screenEnum{
        case TutorialScreen
        case SavedTutorialScreen
        case CodingScreen
    }
    
    var currentScreen: screenEnum = .TutorialScreen
    
    func start() {
       openScreen(screenName: currentScreen)
    }
    
    func openScreen(screenName: screenEnum, pop: Bool = false){
        var vc: Coordinated!
        
        switch screenName{
        case .TutorialScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "TeacherScreenVC") as? TeacherTutorialScreenVC
            //(vc as? TeacherTutorialScreenVC)?.viewDidLoad()
        case .CodingScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "TeacherCodingScreenVC") as? TeacherCodingScreenVC
        case .SavedTutorialScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "TeacherSavedTutorialScreenVC") as? TeacherSavedTutorialScreenVC
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
        navigationController = self.storyboard.instantiateViewController(withIdentifier: "TeacherTutorialsNavController") as! UINavigationController
        self.navigationController.navigationBar.isHidden = true
    }
    
    private static var instance: TeacherTutorialCoordinator!
    public static func getInstance() -> TeacherTutorialCoordinator{
        if(instance == nil){
            instance = TeacherTutorialCoordinator()
        }
        return .instance
    }
}
