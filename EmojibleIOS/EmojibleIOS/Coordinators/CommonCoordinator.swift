//
//  CommonCoordinator.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 12.12.2020.
//

import Foundation
import UIKit

class CommonCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var tabBarController: NavigationMenuBaseController
    var storyboard = UIStoryboard.init(name: "MainApp", bundle: Bundle.main)
    
    var programsNC = OpeningCodingScreenCoordinator.getInstance().navigationController
    var tutorialsNC = TutorialsCoordinator.getInstance().navigationController
    var emojiAssignmentNC = EmojiAssignmentCoordinator.getInstance().navigationController
    var authNC = AuthenticationCoordinator.getInstance().navigationController
    var runCodeNC = RunCodeCoordinator.getInstance().navigationController
    
    var lastIdx = -1
    
    func start() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 0, weight: .semibold, scale: .large)
        
        let programTabBarItem =  UITabBarItem(title: "Programs", image: UIImage(named: "terminal", in: .none, with: configuration), tag: 0)
        
        let tutorialsTabBarItem =  UITabBarItem(title: "Tutorials", image:UIImage(named: "book", in: .none, with: configuration), tag: 1)
        
        let assignmentTabBarItem =  UITabBarItem(title: "Emoji Settings", image:UIImage(named: "face.smiling", in: .none, with: configuration), tag: 2)

        let loginTabBarItem =  UITabBarItem(title: "Login", image: UIImage(named: "person", in: .none, with: configuration), tag: 3)
        
        programsNC.tabBarItem = programTabBarItem
        tutorialsNC.tabBarItem = tutorialsTabBarItem
        emojiAssignmentNC.tabBarItem = assignmentTabBarItem
        authNC.tabBarItem = loginTabBarItem
        
        tabBarController.viewControllers = [programsNC, tutorialsNC, emojiAssignmentNC, authNC, runCodeNC]
        
        tabBarController.selectedIndex = 0
        
        tabBarController.loadTabBar()
        startChildren()
    }
    
    func startChildren(){
        OpeningCodingScreenCoordinator.getInstance().parentCoordinator = self
        OpeningCodingScreenCoordinator.getInstance().start()
    
        TutorialsCoordinator.getInstance().parentCoordinator = self
        TutorialsCoordinator.getInstance().start()

        EmojiAssignmentCoordinator.getInstance().parentCoordinator = self
        EmojiAssignmentCoordinator.getInstance().start()
        
        AuthenticationCoordinator.getInstance().parentCoordinator = self
        AuthenticationCoordinator.getInstance().start()
 
        RunCodeCoordinator.getInstance().parentCoordinator = self
        RunCodeCoordinator.getInstance().start()
    }
    
    private init(){
        tabBarController = self.storyboard.instantiateViewController(withIdentifier: "NavigationMenuBaseController") as! UITabBarController as! NavigationMenuBaseController
        self.tabBarController.navigationController?.navigationBar.isHidden = true
    }
    
    private static var instance:CommonCoordinator!
    public static func getInstance() -> CommonCoordinator{
        if instance == nil{
            instance = CommonCoordinator()
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
