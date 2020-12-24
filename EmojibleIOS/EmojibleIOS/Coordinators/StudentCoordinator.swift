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
<<<<<<< HEAD

    var tabBarController: NavigationMenuBaseController
    var storyboard = UIStoryboard.init(name: "MainApp", bundle: Bundle.main)
    
    var pr: UINavigationController!
    
    var programsNC = ProgramsCoordinator.getInstance().navigationController
    var tutorialsNC = TutorialsCoordinator.getInstance().navigationController
    var emojiAssignmentNC = EmojiAssignmentCoordinator.getInstance().navigationController
    var classroomNC = ClassCoordinator.getInstance().navigationController
    var settingsNC = SettingsCoordinator.getInstance().navigationController
    var runCodeNC = RunCodeCoordinator.getInstance().navigationController
    
    var lastIdx = -1
    
    func start() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 0, weight: .semibold, scale: .large)
        
        let programTabBarItem =  UITabBarItem(title: "Programs", image: UIImage(named: "terminal", in: .none, with: configuration), tag: 0)
        let tutorialsTabBarItem =  UITabBarItem(title: "Tutorials", image:UIImage(named: "book", in: .none, with: configuration), tag: 1)
        let assignmentTabBarItem =  UITabBarItem(title: "Emoji Settings", image:UIImage(named: "face.smiling", in: .none, with: configuration), tag: 2)
        let classroomTabBarItem = UITabBarItem(title: "Class", image:UIImage(named: "studentdesk", in: .none, with: configuration), tag: 3)
        let settingsTabBarItem =  UITabBarItem(title: "Settings", image: UIImage(named: "gear", in: .none, with: configuration), tag: 4)
        
        programsNC.tabBarItem = programTabBarItem
        tutorialsNC.tabBarItem = tutorialsTabBarItem
        emojiAssignmentNC.tabBarItem = assignmentTabBarItem
        classroomNC.tabBarItem = classroomTabBarItem
        settingsNC.tabBarItem = settingsTabBarItem
        
        tabBarController.viewControllers = [programsNC, tutorialsNC, emojiAssignmentNC, classroomNC, settingsNC, runCodeNC]
        tabBarController.selectedIndex = 0
        
        tabBarController.loadTabBar()
        startChildren()
    }
    
    func startChildren(){
        ProgramsCoordinator.getInstance().parentCoordinator = self
        ProgramsCoordinator.getInstance().start()
    
        TutorialsCoordinator.getInstance().parentCoordinator = self
        TutorialsCoordinator.getInstance().start()

        EmojiAssignmentCoordinator.getInstance().parentCoordinator = self
        EmojiAssignmentCoordinator.getInstance().start()
        
        SettingsCoordinator.getInstance().parentCoordinator = self
        SettingsCoordinator.getInstance().start()
        
        ClassCoordinator.getInstance().parentCoordinator = self
        ClassCoordinator.getInstance().start()
 
        RunCodeCoordinator.getInstance().parentCoordinator = self
        RunCodeCoordinator.getInstance().start()
    }
    
    private init(){
        tabBarController = self.storyboard.instantiateViewController(withIdentifier: "NavigationMenuBaseController") as! UITabBarController as! NavigationMenuBaseController
        self.tabBarController.navigationController?.navigationBar.isHidden = true
    }
    
    private static var instance:StudentCoordinator!
=======
    var navigationController = UINavigationController()
    var storyboard = UIStoryboard.init(name: "StudentApp", bundle: Bundle.main)
    

    enum screenEnum{
        case MainScreen
        case CodingScreen
        case TutorialScreen
        case AssignmentScreen
    }
    
    var currentScreen: screenEnum = .MainScreen

    
    func start() {
        openScreen(screenName: currentScreen)
    }
    
    func openScreen(screenName: screenEnum, pop: Bool = false){
        var vc: Coordinated!
        
        switch screenName{
        case .MainScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "StudentMainScreenVC") as? StudentMainScreenVC
        case .CodingScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "CodingScreenVC") as? CodingScreenVC
        case .TutorialScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "TutorialScreenVC") as? TutorialScreenVC
        case .AssignmentScreen:
            vc = self.storyboard.instantiateViewController(withIdentifier: "AssignmentScreenVC") as? AssignmentScreenVC
        }
        
        vc.coordinator = self
        navigationController.delegate = self as? UINavigationControllerDelegate
        if pop { navigationController.popViewController(animated: true) }
        navigationController.pushViewController(vc as! UIViewController, animated: true)
        currentScreen = screenName
    }
    
    
    private init(){
        navigationController = self.storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
    }
    private static let instance = StudentCoordinator()
>>>>>>> main
    public static func getInstance() -> StudentCoordinator{
        return .instance
    }
    
    public func runCode(code:String){
        RunCodeCoordinator.getInstance().runningCode = code
        lastIdx = tabBarController.selectedIndex
        tabBarController.selectedIndex = 5
        tabBarController.setHidden()
    }
    
    public func terminateCode(){
        tabBarController.selectedIndex = lastIdx
        tabBarController.setVisible()
    }
    
    func changeTab(tab: Int) {
        self.tabBarController.changeTab(tab: tab)
    }
}
