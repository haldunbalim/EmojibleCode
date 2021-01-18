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
    @IBOutlet weak var areYouSureLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
    }
    
    func configureLanguage(){
        areYouSureLabel.text = "Are you sure?".localized()
        deleteButton.setTitle("Delete".localized(), for: .normal)
        cancelButton.setTitle("Cancel".localized(), for: .normal)
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
        
        if deleteButton.currentTitle == "Logout".localized(){
            UserDataSource.getInstance().getCurrentUserInfo(){ userModel in
                guard let userModel = userModel else {return}
                _ = AuthenticationManager.getInstance().signOut()
            }
        }
        
        if deleteButton.currentTitle == "Leave".localized() {
            UserDataSource.getInstance().resetUserClassId()
        }
        
        dismiss()
     }
    
    private func dismiss(){
        deleteButton.setTitle("Delete".localized(), for: .normal)
        deleteButton.setTitleColor(#colorLiteral(red: 0.007333596703, green: 0.2443790138, blue: 0.5489466786, alpha: 1), for: .normal)
        removeAssignmentDelegate?.assignmentToBeRemoved = nil
        removeProgramDelegate?.programToBeRemoved = nil
        removeTeacherTutorialDelegate?.tutorialToBeRemoved = nil
        removeTeacherClassDelegate?.classToBeRemoved = nil
        self.dismiss(animated: true, completion: nil)
    }
}

