//
//  EditAlert.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 27.11.2020.
//

import UIKit
class EditAlert: CustomAlertViewController{
    
    var editAssignmentDelegate: AssignmentEditAlert?
    
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
    
    @IBAction func updateButtonOnPress(_ sender: Any) {
        guard let text = valueTextField.text, text != "" else {
            showMessagePrompt("Text cannot be empty", vcToBePresented: delegate!)
            return
        }
        
        if let assignment = editAssignmentDelegate?.assignmentToBeEdited {
            GlobalMemory.getInstance().editAssignment(assignment: assignment, newValue: text)
        }
        
        dismiss()
     }
    
    private func dismiss(){
        valueTextField.text = ""
        valueTextField.resignFirstResponder()
        self.editAssignmentDelegate?.assignmentToBeEdited = nil
        self.dismiss(animated: true, completion: nil)
    }
}
