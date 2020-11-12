//
//  LoginScreenVC.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
import UIKit

class LoginVC: UIViewController, Coordinated, UIViewControllerWithAlerts{
    var coordinator: Coordinator?
    var pleaseWaitAlert: UIAlertController?

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, email != "" else {
            showMessagePrompt("E-mail cannot be empty", vcToBePresented: self)
            return
        }
        
        guard let password = passwordTextField.text, password != "" else {
            showMessagePrompt("Password cannot be empty", vcToBePresented: self)
            return
        }
        self.showSpinner(){
            AuthenticationManager.getInstance().signInWithEmailAndPassword(email: email, password: password){[unowned self] error in
                if let error = error {
                    self.hideSpinner()
                    showMessagePrompt(error, vcToBePresented: self)
                }else{
                    self.hideSpinner()
                }
            }
        }
    }
    
    @IBAction func forgetYourPasswordButtonPressed(_ sender: UIButton) {
        (self.coordinator as! AuthenticationCoordinator).openScreen(screenName: .ForgetPassword)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        guard let coordinator = coordinator as? AuthenticationCoordinator else { return }
        coordinator.registeringUserType = sender.tag == 0 ? "Student":"Teacher"
        coordinator.openScreen(screenName: .Register)
    }
    
}
