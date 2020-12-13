//
//  ClassSignUpVC.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
import UIKit

class ClassSignUpVC:UIViewController, Coordinated, UIViewControllerWithAlerts{
    var pleaseWaitAlert: UIAlertController?
    var coordinator: Coordinator?

    @IBOutlet weak var enrollLabel: UILabel!
    @IBOutlet weak var classCodeTextField: UITextField!
    @IBOutlet weak var classPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    func configureViews(){
        NSLayoutConstraint.activate([classPasswordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
        NSLayoutConstraint.activate([classCodeTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
        NSLayoutConstraint.activate([enrollLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        guard let classCode = classCodeTextField.text, classCode != "" else {
            showMessagePrompt("Class Code cannot be empty", vcToBePresented: self)
            return
        }
        
        guard let classPassword = classPasswordTextField.text, classPassword != "" else {
            showMessagePrompt("Class Password cannot be empty", vcToBePresented: self)
            return
        }
    }
}
