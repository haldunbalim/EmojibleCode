//
//  ForgetPasswordVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import Foundation
import UIKit

class ForgetPasswordVC: UIViewController, Coordinated, UIViewControllerWithAlerts{
    var pleaseWaitAlert: UIAlertController?
    var coordinator: Coordinator?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var getLinkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        configureViews()
        configureLanguage()
    }
    func configureLanguage(){
        backButton.setTitle("BACK".localized(), for: .normal)
        getLinkButton.setTitle("Get reset link".localized(), for: .normal)
        emailTextField.placeholder = "Enter your e-mail".localized()
    }
    
    func configureViews(){
        NSLayoutConstraint.activate([emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
        NSLayoutConstraint.activate([getLinkButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
        NSLayoutConstraint.activate([backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH)])
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        emailTextField.text = ""
        (self.coordinator as! AuthenticationCoordinator).pop()
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, email != "" else {
            showMessagePrompt("E-mail cannot be empty", vcToBePresented: self)
            return
        }
        
        self.showSpinner(){
            AuthenticationManager.getInstance().resetPassword(email: email){[unowned self] error in
                if let error = error {
                    self.hideSpinner()
                    showMessagePrompt(error, vcToBePresented: self)
                }else{
                    self.hideSpinner()
                    showMessagePrompt("Password reset e-mail has been sent", vcToBePresented: self)
                }
            }
        }
    }
}
