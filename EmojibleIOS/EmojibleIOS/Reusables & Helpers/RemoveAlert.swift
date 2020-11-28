//
//  AddRemoveAlert.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 19.11.2020.
//

import UIKit

class RemoveAlert: CustomAlertViewController{
    
    var removeAssignmentDelegate: AssignmentRemovalAlert?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonOnPress(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func deleteButtonOnPress(_ sender: Any) {
        if let assignment = removeAssignmentDelegate?.assignmentToBeRemoved {
            GlobalMemory.getInstance().removeContent(assignment: assignment)
        }
        dismiss()
     }
    
    private func dismiss(){
        removeAssignmentDelegate?.assignmentToBeRemoved = nil
        self.dismiss(animated: true, completion: nil)
    }
}

