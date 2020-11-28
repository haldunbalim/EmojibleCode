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
    
    
    func start() {
        let programTabBarItem =  UITabBarItem(title: "Programs", image: UIImage(systemName: "terminal"), tag: 0)
        
        let tutorialsTabBarItem =  UITabBarItem(title: "Tutorials", image:UIImage(systemName: "book"), tag: 1)
        
        let assignmentTabBarItem =  UITabBarItem(title: "Emoji Settings", image:UIImage(systemName: "face.smiling"), tag: 2)

        let settingsTabBarItem =   UITabBarItem(title: "Settings", image: UIImage(systemName: "person"), tag: 3)
        
        
        programsNC.tabBarItem = programTabBarItem
        tutorialsNC.tabBarItem = tutorialsTabBarItem
        emojiAssignmentNC.tabBarItem = assignmentTabBarItem
        settingsNC.tabBarItem = settingsTabBarItem
        
        tabBarController.viewControllers = [programsNC, tutorialsNC, emojiAssignmentNC, settingsNC]
        tabBarController.selectedIndex = 0
        
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
    
}
