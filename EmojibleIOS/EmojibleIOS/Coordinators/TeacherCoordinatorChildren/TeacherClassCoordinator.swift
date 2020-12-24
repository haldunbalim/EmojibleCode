//
//  TeacherClassCoordinator.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 15.12.2020.
//

import Foundation
import UIKit

class TeacherClassCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var navigationController:UINavigationController
    var storyboard = UIStoryboard.init(name: "MainApp", bundle: Bundle.main)
    
    var classroom: ClassModel?
    
    enum screenEnum{
       case ClassScreen
       case StudentInfo
    }
    
    var currentScreen: screenEnum = .ClassScreen
    
    func start() {
        openScreen(screenName: currentScreen)
    }
    
    func openScreen(screenName: screenEnum, pop: Bool = false){
        var vc: Coordinated!
        
        switch screenName{
        case .ClassScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "TeacherClassVC") as? TeacherClassVC
        case .StudentInfo:
            vc = self.storyboard.instantiateViewController(withIdentifier: "TeacherStudentEnrollmentVC") as? TeacherStudentEnrollmentVC
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
        navigationController = self.storyboard.instantiateViewController(withIdentifier: "TeacherClassNavController") as! UINavigationController
        self.navigationController.navigationBar.isHidden = true
    }
    
    private static var instance: TeacherClassCoordinator!
    public static func getInstance() -> TeacherClassCoordinator{
        if(instance == nil){
            instance = TeacherClassCoordinator()
        }
        return .instance
    }
}
