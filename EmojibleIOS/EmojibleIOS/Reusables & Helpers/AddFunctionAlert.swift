//
//  AddFunctionAlert.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 18.11.2020.
//

import Foundation
import UIKit
class AddFunctionAlert: CustomAlertViewController{
    
    var newFunctiontAssignmentDelegate: AssignmentNewAssignmentAlert?
    
    @IBOutlet weak var valueTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        valueTextField.becomeFirstResponder()
    }
    

    @IBAction func cancelButtonOnPress(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func assignButtonOnPress(_ sender: Any) {
        
        guard let text = valueTextField.text, text != "" else {
            showMessagePrompt("Text cannot be empty", vcToBePresented: delegate!)
            return
        }
        
        if let identifier = newFunctiontAssignmentDelegate?.newAssignmentIdentifier{
            GlobalMemory.getInstance().addAssignment(assignment: AssignmentModel(identifier: identifier, value: text))
        }
        dismiss()
     }
    
    private func dismiss(){
        valueTextField.text = ""
        valueTextField.resignFirstResponder()
        newFunctiontAssignmentDelegate?.newAssignmentIdentifier = nil
        self.dismiss(animated: true, completion: nil)
    }
 
}
