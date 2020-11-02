//
//  AppDelegate.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 29.10.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow()
        self.appCoordinator = AppCoordinator(window: self.window!)
        appCoordinator!.start()
        
        return true
    }



}

