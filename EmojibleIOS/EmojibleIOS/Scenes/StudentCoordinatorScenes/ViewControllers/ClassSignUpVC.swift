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
    
    @IBOutlet weak var classCodeTextField: UITextField!
    @IBOutlet weak var classPasswordTextField: UITextField!
    
    
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
