//
//  AddTextAlert.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 13.11.2020.
//

import Foundation
import UIKit
class AddTextAlert: CustomAlertViewController{
    
    var newTextAssignmentDelegate: AssignmentNewAssignmentAlert?
    var editAssignmentDelegate: AssignmentEditAlert?
    
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var assignButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        valueTextField.becomeFirstResponder()
    }
    
    func configureLanguage(){
        valueTextField.placeholder = "Text".localized()
        cancelButton.setTitle("Cancel".localized(), for: .normal)
        assignButton.setTitle("Assign".localized(), for: .normal)
    }
    
    @IBAction func cancelButtonOnPress(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func assignButtonOnPress(_ sender: Any) {
        guard let text = valueTextField.text, text != "" else {
            showMessagePrompt("Text cannot be empty", vcToBePresented: delegate!)
            return
        }
        
        if let identifier = newTextAssignmentDelegate?.newAssignmentIdentifier{
            GlobalMemory.getInstance().addAssignment(assignment: AssignmentModel(identifier: identifier, value: text))
        }
        
        if let assignment = editAssignmentDelegate?.assignmentToBeEdited {
            GlobalMemory.getInstance().editAssignment(assignment: assignment, newValue: text)
        }
    
        dismiss()
     }
    
    private func dismiss(){
        valueTextField.text = ""
        valueTextField.resignFirstResponder()
        newTextAssignmentDelegate?.newAssignmentIdentifier = nil
        editAssignmentDelegate?.assignmentToBeEdited = nil
        self.dismiss(animated: true, completion: nil)
    }
}
