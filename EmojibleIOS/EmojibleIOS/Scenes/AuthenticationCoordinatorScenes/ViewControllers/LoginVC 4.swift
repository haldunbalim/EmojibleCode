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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetYourPasswordButton: UIButton!
    @IBOutlet weak var createStudentAccountButton: UIButton!
    @IBOutlet weak var createTeacherAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        configureViews()
    }
    
    func configureViews(){
        NSLayoutConstraint.activate([emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
        NSLayoutConstraint.activate([passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
        NSLayoutConstraint.activate([loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
        NSLayoutConstraint.activate([forgetYourPasswordButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
        NSLayoutConstraint.activate([createStudentAccountButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
        NSLayoutConstraint.activate([createTeacherAccountButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let coordinator = coordinator else{
            return
        }
<<<<<<< HEAD
        
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
                    resetFields()
                    self.hideSpinner()
                }
            }
        }
    }
    
    func resetFields(){
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
=======
        AuthenticationManager.getInstance().isLoggedIn = true
        (coordinator.parentCoordinator as! AppCoordinator).start()
    }
>>>>>>> main
    @IBAction func forgetYourPasswordButtonPressed(_ sender: UIButton) {
        resetFields()
        (self.coordinator as! AuthenticationCoordinator).openScreen(screenName: .ForgetPassword)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
<<<<<<< HEAD
        resetFields()
        guard let coordinator = coordinator as? AuthenticationCoordinator else { return }
        coordinator.registeringUserType = sender.tag == 0 ? "Student":"Teacher"
        coordinator.openScreen(screenName: .Register)
=======
        (self.coordinator as! AuthenticationCoordinator).openScreen(screenName: .Register)
>>>>>>> main
    }
    
}
