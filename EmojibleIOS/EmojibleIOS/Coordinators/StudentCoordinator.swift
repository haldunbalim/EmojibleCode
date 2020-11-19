//
//  StudentCoordinator.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
import UIKit

class StudentCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    //var navigationControllers: [UINavigationController]!
    //var tabBarController: UIViewController
    
    var tabBarController: UITabBarController
    var storyboard = UIStoryboard.init(name: "StudentApp", bundle: Bundle.main)
    
    var tutorialsNC = TutorialsCoordinator.getInstance().navigationController
    var emojiAssignmentNC = EmojiAssignmentCoordinator.getInstance().navigationController
    var programsNC = ProgramsCoordinator.getInstance().navigationController
    //var classNC = ClassCoordinator.getInstance().navigationController
    var settingsNC = SettingsCoordinator.getInstance().navigationController
    
    /*
    enum screenEnum{
        case ProgramScreen
        case TutorialsScreen
        case SettingsScreen
        case AssignmentScreen
    }
    var currentScreen : screenEnum = .ProgramScreen
     */
    
    func start() {
        
        let programTabBarItem =  UITabBarItem(title: "Create Program", image: UIImage(systemName: "plus.circle"), tag: 0)
        
        let tutorialsTabBarItem =  UITabBarItem(title: "Tutorials", image:UIImage(systemName: "questionmark.circle"), tag: 1)
        
        let assignmentTabBarItem =  UITabBarItem(title: "Emoji Settings", image:UIImage(systemName: "equal.circle"), tag: 2)

        //let classTabBarItem =   UITabBarItem(title: "My Class", image: UIImage(systemName: "person.3.fill"), tag: 3)
        
        let settingsTabBarItem =   UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 3)
        
        programsNC.tabBarItem = programTabBarItem
        tutorialsNC.tabBarItem = tutorialsTabBarItem
        emojiAssignmentNC.tabBarItem = assignmentTabBarItem
        //classNC.tabBarItem = classTabBarItem
        settingsNC.tabBarItem = settingsTabBarItem
        
        startChildren()
        tabBarController.viewControllers = [programsNC, tutorialsNC, emojiAssignmentNC, settingsNC]
        tabBarController.selectedIndex = 0
        
        
        /*
        startChildren()
        navigationControllers = [programsNC, tutorialsNC, emojiAssignmentNC, settingsNC]
        openScreen(screenName: currentScreen)
         */
    }
    
    func startChildren(){
            TutorialsCoordinator.getInstance().parentCoordinator = self
            TutorialsCoordinator.getInstance().start()

            EmojiAssignmentCoordinator.getInstance().parentCoordinator = self
            EmojiAssignmentCoordinator.getInstance().start()
                
            ProgramsCoordinator.getInstance().parentCoordinator = self
            ProgramsCoordinator.getInstance().start()
            
            //ClassCoordinator.getInstance().parentCoordinator = self
            //ClassCoordinator.getInstance().start()
                
            SettingsCoordinator.getInstance().parentCoordinator = self
            SettingsCoordinator.getInstance().start()
            
        }
    /*
    func openScreen(screenName: screenEnum, pop: Bool = false){
        var vc: Coordinated!
        
        switch screenName{
        case .ProgramScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        case .TutorialsScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC
        case .SettingsScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "ForgetPasswordVC") as? ForgetPasswordVC
        case .AssignmentScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "ForgetPasswordVC") as? ForgetPasswordVC
        }
        
        vc.coordinator = self
    }
    */
    
    private init(){
        tabBarController = self.storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
    }
    
    private static var instance:StudentCoordinator!
    
    public static func getInstance() -> StudentCoordinator{
        if instance == nil{
            instance = StudentCoordinator()
        }
        return .instance
    }
    
}
