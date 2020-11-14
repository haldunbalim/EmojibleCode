//
//  AddTextAlert.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 13.11.2020.
//

import Foundation
import UIKit
class AddTextAlert: CustomAlertViewController{
    
    @IBOutlet weak var identifierTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        identifierTextField.becomeFirstResponder()
        valueTextField.becomeFirstResponder()
    }
    
    
    @IBAction func cancelButtonOnPress(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func assignButtonOnPress(_ sender: Any) {
        guard let identifier = identifierTextField.text, identifier != "" else {
            showMessagePrompt("Identifier cannot be empty", vcToBePresented: delegate!)
            return
        }
        
        guard let text = valueTextField.text, text != "" else {
            showMessagePrompt("Text cannot be empty", vcToBePresented: delegate!)
            return
        }
        
        if !EmojiChecker.getInstance().isValidIdentifier(identifier){
            showMessagePrompt("\(identifier) is  not a valid identifier. Please enter a single emoji as identifier", vcToBePresented: delegate!)
            return
        }
        
        GlobalMemory.getInstance().addAssignment(assignment: AssignmentModel(identifier: identifier, value: text))
        dismiss()
     }
    
    private func dismiss(){
         identifierTextField.text = ""
         valueTextField.text = ""
         identifierTextField.resignFirstResponder()
         valueTextField.resignFirstResponder()
         self.dismiss(animated: true, completion: nil)
    }
}
