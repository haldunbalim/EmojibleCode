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
    var removeTeacherTutorialDelegate: TeacherTutorialRemovalAlert?
    var removeTeacherClassDelegate: TeacherClassRemovalAlert?
    
    @IBOutlet weak var deleteButton: UIButton!
    
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
        
        if let teacherTutorial = removeTeacherTutorialDelegate?.tutorialToBeRemoved{
            TeacherTutorialDataSource.getInstance().removeTutorial(tutorial: teacherTutorial)
        }
        
        if let teacherClass = removeTeacherClassDelegate?.classToBeRemoved{
            TeacherClassDataSource.getInstance().removeClass(classroom: teacherClass)
        }
        
        if deleteButton.currentTitle == "LogOut"{
            UserDataSource.getInstance().getCurrentUserInfo(){ userModel in
                guard let userModel = userModel else {return}
                _ = AuthenticationManager.getInstance().signOut()
            }
        }
        
        if deleteButton.currentTitle == "Leave" {
            UserDataSource.getInstance().resetUserClassId()
        }
        
        dismiss()
     }
    
    private func dismiss(){
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(#colorLiteral(red: 0.007333596703, green: 0.2443790138, blue: 0.5489466786, alpha: 1), for: .normal)
        removeAssignmentDelegate?.assignmentToBeRemoved = nil
        removeProgramDelegate?.programToBeRemoved = nil
        removeTeacherTutorialDelegate?.tutorialToBeRemoved = nil
        removeTeacherClassDelegate?.classToBeRemoved = nil
        self.dismiss(animated: true, completion: nil)
    }
}

