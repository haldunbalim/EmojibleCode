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
    var isStarted:Bool = false
    
    func start() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 0, weight: .semibold, scale: .large)
        
        let programTabBarItem =  UITabBarItem(title: "Create Program".localized(), image: UIImage(named: "terminal", in: .none, with: configuration), tag: 0)
        
        let tutorialsTabBarItem =  UITabBarItem(title: "Tutorials".localized(), image:UIImage(named: "book", in: .none, with: configuration), tag: 1)
        
        let assignmentTabBarItem =  UITabBarItem(title: "Emoji Settings".localized(), image:UIImage(named: "face.smiling", in: .none, with: configuration), tag: 2)

        let loginTabBarItem =  UITabBarItem(title: "Login".localized(), image: UIImage(named: "person", in: .none, with: configuration), tag: 3)
        
        programsNC.tabBarItem = programTabBarItem
        tutorialsNC.tabBarItem = tutorialsTabBarItem
        emojiAssignmentNC.tabBarItem = assignmentTabBarItem
        authNC.tabBarItem = loginTabBarItem
        
        tabBarController.selectedIndex = 0
        tabBarController.viewControllers = [programsNC, tutorialsNC, emojiAssignmentNC, authNC, runCodeNC]
        
        resetToInitialState()
        tabBarController.loadTabBar()
        setParent()
        
        if !isStarted{
            startChildren()
            isStarted = true
        }
    }
    
    func resetToInitialState(){
        TutorialsCoordinator.getInstance().pop()
        AuthenticationCoordinator.getInstance().pop()
    }
    
    func startChildren(){
        OpeningCodingScreenCoordinator.getInstance().start()
        TutorialsCoordinator.getInstance().start()
        EmojiAssignmentCoordinator.getInstance().start()
        AuthenticationCoordinator.getInstance().start()
        RunCodeCoordinator.getInstance().start()
    }
    
    func setParent(){
        OpeningCodingScreenCoordinator.getInstance().parentCoordinator = self
        TutorialsCoordinator.getInstance().parentCoordinator = self
        EmojiAssignmentCoordinator.getInstance().parentCoordinator = self
        AuthenticationCoordinator.getInstance().parentCoordinator = self
        RunCodeCoordinator.getInstance().parentCoordinator = self
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
