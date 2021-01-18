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
    var classNC = TeacherClassCoordinator.getInstance().navigationController
    var settingsNC = SettingsCoordinator.getInstance().navigationController
    var runCodeNC = RunCodeCoordinator.getInstance().navigationController
    
    var lastIdx = -1
    var isStarted: Bool = false
    
    func start() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 0, weight: .semibold, scale: .large)
        
        let tutorialsTabBarItem =  UITabBarItem(title: "Tutorials".localized(), image: UIImage(named: "book", in: .none, with: configuration), tag: 0)
        
        let assignmentTabBarItem =  UITabBarItem(title: "Emoji Settings".localized(), image:UIImage(named: "face.smiling", in: .none, with: configuration), tag: 1)
        
        let classTabBarItem = UITabBarItem(title: "Class".localized(), image:UIImage(named: "studentdesk", in: .none, with: configuration), tag: 2)

        let settingsTabBarItem =  UITabBarItem(title: "Settings".localized(), image: UIImage(named: "gear", in: .none, with: configuration), tag: 3)
        
        tutorialsNC.tabBarItem = tutorialsTabBarItem
        emojiAssignmentNC.tabBarItem = assignmentTabBarItem
        classNC.tabBarItem = classTabBarItem
        settingsNC.tabBarItem = settingsTabBarItem
        
        
        tabBarController.selectedIndex = 0
        tabBarController.viewControllers = [tutorialsNC, emojiAssignmentNC, classNC, settingsNC, runCodeNC]
        
        resetToInitialState()
        tabBarController.loadTabBar()
        setParent()
        
        if !isStarted{
            startChildren()
            isStarted = true
        }
    }
    
    func resetToInitialState(){
        TeacherTutorialCoordinator.getInstance().pop()
        TeacherClassCoordinator.getInstance().pop()
        SettingsCoordinator.getInstance().pop()
    }
    
    func startChildren(){
        TeacherTutorialCoordinator.getInstance().start()
        EmojiAssignmentCoordinator.getInstance().start()
        TeacherClassCoordinator.getInstance().start()
        SettingsCoordinator.getInstance().start()
        RunCodeCoordinator.getInstance().start()
    }
    
    func setParent(){
        TeacherTutorialCoordinator.getInstance().parentCoordinator = self
        EmojiAssignmentCoordinator.getInstance().parentCoordinator = self
        TeacherClassCoordinator.getInstance().parentCoordinator = self
        SettingsCoordinator.getInstance().parentCoordinator = self
        RunCodeCoordinator.getInstance().parentCoordinator = self
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
