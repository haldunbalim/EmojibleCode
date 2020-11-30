//
//  NavigationMenuBaseController.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 22.11.2020.
//

import UIKit

class NavigationMenuBaseController: UITabBarController, UITabBarControllerDelegate {
    
    var customTabBar: TabNavigationMenu!
    var tabBarWidth: CGFloat = Constants.TAB_BAR_WIDTH
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    public func loadTabBar() {
        var tabItems = [UITabBarItem]()
        for i in 0 ..< self.viewControllers!.count {
            tabItems.append(self.viewControllers![i].tabBarItem)
        }
        self.setupCustomTabBar(tabItems) {
            (controllers) in self.viewControllers = controllers
        }
    }
    
    private func setupCustomTabBar(_ items: [UITabBarItem], completion: @escaping ([UIViewController]) -> Void){
        let frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: tabBarWidth, height: self.view.frame.height)
        
        var controllers = [UIViewController]()
        
        tabBar.isHidden = true
        
        self.customTabBar = TabNavigationMenu(menuItems: items, frame: frame)
        self.customTabBar.translatesAutoresizingMaskIntoConstraints = false
        self.customTabBar.clipsToBounds = true
        self.customTabBar.itemTapped = self.changeTab
        
        self.view.addSubview(customTabBar)
        
        NSLayoutConstraint.activate([
            self.customTabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.customTabBar.widthAnchor.constraint(equalToConstant: tabBarWidth),
            self.customTabBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.customTabBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        for i in 0 ..< self.viewControllers!.count {
            controllers.append(self.viewControllers![i])
        }
        
        self.view.layoutIfNeeded()
        completion(controllers)
    }
    
    func changeTab(tab: Int) {
        self.selectedIndex = tab
    }
}
