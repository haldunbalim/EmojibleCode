//
//  AppDelegate.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 29.10.2020.
//

import UIKit
import Firebase
import FBSDKCoreKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        VisionModel.getInstance().imageToEmojiString(img: UIImage(named: "guess_game_editted")!)
        //forcedLogOut()
        self.window = UIWindow()
        self.appCoordinator = AppCoordinator(window: self.window!)
        
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        return true
    }

              
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
   func forcedLogOut(){
       //LoginManager().logOut()
       try! Auth.auth().signOut()
    }


}




