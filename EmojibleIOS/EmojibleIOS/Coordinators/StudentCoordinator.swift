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
    var tabBarController: UITabBarController
    var storyboard = UIStoryboard.init(name: "StudentApp", bundle: Bundle.main)
    
    var tutorialsNC = TutorialsCoordinator.getInstance().navigationController
    var emojiAssignmentNC = EmojiAssignmentCoordinator.getInstance().navigationController
    var createNewCodeNC = CreateNewCodeCoordinator.getInstance().navigationController
    var classNC = ClassCoordinator.getInstance().navigationController
    var settingsNC = SettingsCoordinator.getInstance().navigationController
    
    func start() {
        let tutorialsTabBarItem =  UITabBarItem(title: "Tutorials", image:UIImage(systemName: "questionmark.circle"), tag: 0)
        let assignmentTabBarItem =  UITabBarItem(title: "Assignment", image:UIImage(systemName: "equal.circle"), tag: 1)
        let createTabBarItem =  UITabBarItem(title: "New Code", image: UIImage(systemName: "plus.circle"), tag: 2)
        let classTabBarItem =   UITabBarItem(title: "My Class", image: UIImage(systemName: "person.3.fill"), tag: 3)
        let settingsTabBarItem =   UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)
       
        tutorialsNC.tabBarItem = tutorialsTabBarItem
        emojiAssignmentNC.tabBarItem = assignmentTabBarItem
        createNewCodeNC.tabBarItem = createTabBarItem
        classNC.tabBarItem = classTabBarItem
        settingsNC.tabBarItem = settingsTabBarItem
        
        startChildren()
        tabBarController.viewControllers = [tutorialsNC, emojiAssignmentNC, createNewCodeNC , classNC, settingsNC]
        tabBarController.selectedIndex = 2
    }
    
    func startChildren(){
            TutorialsCoordinator.getInstance().parentCoordinator = self
            TutorialsCoordinator.getInstance().start()

            EmojiAssignmentCoordinator.getInstance().parentCoordinator = self
            EmojiAssignmentCoordinator.getInstance().start()
                
            CreateNewCodeCoordinator.getInstance().parentCoordinator = self
            CreateNewCodeCoordinator.getInstance().start()
            
            ClassCoordinator.getInstance().parentCoordinator = self
            ClassCoordinator.getInstance().start()
                
            SettingsCoordinator.getInstance().parentCoordinator = self
            SettingsCoordinator.getInstance().start()
        }
    
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
