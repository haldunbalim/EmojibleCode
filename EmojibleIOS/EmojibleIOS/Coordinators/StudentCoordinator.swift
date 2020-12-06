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

    var tabBarController: NavigationMenuBaseController
    var storyboard = UIStoryboard.init(name: "StudentApp", bundle: Bundle.main)
    
    
    var programsNC = ProgramsCoordinator.getInstance().navigationController
    var tutorialsNC = TutorialsCoordinator.getInstance().navigationController
    var emojiAssignmentNC = EmojiAssignmentCoordinator.getInstance().navigationController
    var settingsNC = SettingsCoordinator.getInstance().navigationController
    var authNC = AuthenticationCoordinator.getInstance().navigationController
    var runCodeNC = RunCodeCoordinator.getInstance().navigationController
    
    var lastIdx = -1
    
    
    func start() {
        let programTabBarItem =  UITabBarItem(title: "Programs", image: UIImage(named: "terminal"), tag: 0)
        
        let tutorialsTabBarItem =  UITabBarItem(title: "Tutorials", image:UIImage(named: "book"), tag: 1)
        
        let assignmentTabBarItem =  UITabBarItem(title: "Emoji Settings", image:UIImage(named: "face.smiling"), tag: 2)

        let settingsTabBarItem =  UITabBarItem(title: "Settings", image: UIImage(named: "person"), tag: 3)
        
        let fourthTab = AuthenticationManager.getInstance().currentUser == nil ? authNC:settingsNC
        
        programsNC.tabBarItem = programTabBarItem
        tutorialsNC.tabBarItem = tutorialsTabBarItem
        emojiAssignmentNC.tabBarItem = assignmentTabBarItem
        fourthTab.tabBarItem = settingsTabBarItem
        
        tabBarController.viewControllers = [programsNC, tutorialsNC, emojiAssignmentNC, fourthTab, runCodeNC]
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
        
        if AuthenticationManager.getInstance().currentUser == nil{
            AuthenticationCoordinator.getInstance().parentCoordinator = self
            AuthenticationCoordinator.getInstance().start()
        }else{
            SettingsCoordinator.getInstance().parentCoordinator = self
            SettingsCoordinator.getInstance().start()
        }
 
        RunCodeCoordinator.getInstance().parentCoordinator = self
        RunCodeCoordinator.getInstance().start()
        
    }
    
    private init(){
        tabBarController = self.storyboard.instantiateViewController(withIdentifier: "NavigationMenuBaseController") as! UITabBarController as! NavigationMenuBaseController
    }
    
    private static var instance:StudentCoordinator!
    
    public static func getInstance() -> StudentCoordinator{
        if instance == nil{
            instance = StudentCoordinator()
        }
        return .instance
    }
    
    public func runCode(code:String){
        RunCodeCoordinator.getInstance().runningCode = code
        lastIdx = tabBarController.selectedIndex
        tabBarController.selectedIndex = 4
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
