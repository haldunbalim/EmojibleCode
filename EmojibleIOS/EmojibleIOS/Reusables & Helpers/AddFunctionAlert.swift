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
    var editAssignmentDelegate: AssignmentEditAlert?
    
    @IBOutlet weak var valueTextField: UITextView!
    @IBOutlet weak var assignButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        valueTextField.becomeFirstResponder()
    }
    func configureLanguage(){
        valueTextField.text = "Write your code...".localized()
        cancelButton.setTitle("Cancel".localized(), for: .normal)
        assignButton.setTitle("Assign".localized(), for: .normal)
    }

    @IBAction func cancelButtonOnPress(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func assignButtonOnPress(_ sender: Any) {
        
        guard var text = valueTextField.text, text != "" else {
            showMessagePrompt("Text cannot be empty", vcToBePresented: delegate!)
            return
        }
        
        if let identifier = newFunctiontAssignmentDelegate?.newAssignmentIdentifier{
            text = Constants.FUNCTION_IDENTIFIER_PREFIX + text
            GlobalMemory.getInstance().addAssignment(assignment: AssignmentModel(identifier: identifier, value: text))
        }
        
        if let assignment = editAssignmentDelegate?.assignmentToBeEdited {
            GlobalMemory.getInstance().editAssignment(assignment: assignment, newValue: text)
        }
        
        dismiss()
     }
    
    private func dismiss(){
        valueTextField.text = "Write your code...".localized()
        valueTextField.resignFirstResponder()
        newFunctiontAssignmentDelegate?.newAssignmentIdentifier = nil
        editAssignmentDelegate?.assignmentToBeEdited = nil
        self.dismiss(animated: true, completion: nil)
    }
}
