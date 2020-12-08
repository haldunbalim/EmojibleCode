//
//  AddRemoveAlert.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 19.11.2020.
//

import UIKit

class RemoveAlert: CustomAlertViewController{
    
    var removeAssignmentDelegate: AssignmentRemovalAlert?
    var removeProgramDelegate: ProgramRemovalAlert?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonOnPress(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func deleteButtonOnPress(_ sender: Any) {
        if let assignment = removeAssignmentDelegate?.assignmentToBeRemoved {
            GlobalMemory.getInstance().removeContent(assignment: assignment)
            _ = FileSystemManager.getInstance().deleteFile(filename: "\(assignment.identifier).m4a")
        }
        
        if let program = removeProgramDelegate?.programToBeRemoved{
            ProgramDataSource.getInstance().removeProgram(program: program)
        }
        
        dismiss()
     }
    
    private func dismiss(){
        removeAssignmentDelegate?.assignmentToBeRemoved = nil
        removeProgramDelegate?.programToBeRemoved = nil
        self.dismiss(animated: true, completion: nil)
    }
}

