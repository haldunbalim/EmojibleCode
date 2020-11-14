//
//  LoginScreenVC.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
import UIKit

class LoginVC: UIViewController, Coordinated{
    var coordinator: Coordinator?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pressTheButton(_ sender: Any) {
        print("hello")
        (self.coordinator as! AuthenticationCoordinator).openScreen(screenName: .Register)
    }


}
