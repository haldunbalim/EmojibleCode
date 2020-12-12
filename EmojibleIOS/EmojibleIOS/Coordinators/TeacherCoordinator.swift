//
//  TeacherCoordinator.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
import UIKit

class TeacherCoordinator: Coordinator {
    var parentCoordinator: Coordinator?

    var tabBarController: NavigationMenuBaseController
    var storyboard = UIStoryboard.init(name: "MainApp", bundle: Bundle.main)
    
    var tutorialsNC = TeacherTutorialCoordinator.getInstance().navigationController
    var emojiAssignmentNC = EmojiAssignmentCoordinator.getInstance().navigationController
    var settingsNC = SettingsCoordinator.getInstance().navigationController
    var runCodeNC = RunCodeCoordinator.getInstance().navigationController
    
    var lastIdx = -1
    
    func start(){
        let configuration = UIImage.SymbolConfiguration(pointSize: 1, weight: .semibold, scale: .large)
        
        let tutorialsTabBarItem =  UITabBarItem(title: "Tutorials", image: UIImage(named: "book", in: .none, with: configuration), tag: 0)
        
        let assignmentTabBarItem =  UITabBarItem(title: "Emoji Settings", image:UIImage(named: "face.smiling", in: .none, with: configuration), tag: 2)

        let settingsTabBarItem =  UITabBarItem(title: "Settings", image: UIImage(named: "gear", in: .none, with: configuration), tag: 3)
        
        
        tutorialsNC.tabBarItem = tutorialsTabBarItem
        emojiAssignmentNC.tabBarItem = assignmentTabBarItem
        settingsNC.tabBarItem = settingsTabBarItem
        
        tabBarController.viewControllers = [tutorialsNC, emojiAssignmentNC, settingsNC, runCodeNC]
        tabBarController.selectedIndex = 0
        
        tabBarController.loadTabBar()
        startChildren()
    }
    
    func startChildren(){
        TeacherTutorialCoordinator.getInstance().parentCoordinator = self
        TeacherTutorialCoordinator.getInstance().start()

        EmojiAssignmentCoordinator.getInstance().parentCoordinator = self
        EmojiAssignmentCoordinator.getInstance().start()
        
        SettingsCoordinator.getInstance().parentCoordinator = self
        SettingsCoordinator.getInstance().start()
 
        RunCodeCoordinator.getInstance().parentCoordinator = self
        RunCodeCoordinator.getInstance().start()
    }
    
    private init(){
        tabBarController = self.storyboard.instantiateViewController(withIdentifier: "NavigationMenuBaseController") as! UITabBarController as! NavigationMenuBaseController
        self.tabBarController.navigationController?.navigationBar.isHidden = true
    }
    
    private static var instance:TeacherCoordinator!
    public static func getInstance() -> TeacherCoordinator{
        if instance == nil{
            instance = TeacherCoordinator()
        }
        return .instance
    }
    
    
    public func runCode(code:String){
        RunCodeCoordinator.getInstance().runningCode = code
        lastIdx = tabBarController.selectedIndex
        tabBarController.selectedIndex = 3
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
