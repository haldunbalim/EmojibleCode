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

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let coordinator = coordinator else{
            return
        }
        AuthenticationManager.getInstance().isLoggedIn = true
        (coordinator.parentCoordinator as! AppCoordinator).start()
    }
    @IBAction func forgetYourPasswordButtonPressed(_ sender: UIButton) {
        (self.coordinator as! AuthenticationCoordinator).openScreen(screenName: .ForgetPassword)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        (self.coordinator as! AuthenticationCoordinator).openScreen(screenName: .Register)
    }
    
}
