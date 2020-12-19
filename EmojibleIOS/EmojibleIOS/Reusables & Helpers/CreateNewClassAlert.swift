//
//  CreateNewClass.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 15.12.2020.
//

import UIKit

class CreateNewClassAlert: CustomAlertViewController{
    
    var warningDelegate: WarningAlert?
    
    @IBOutlet weak var classNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func cancelButtonOnPress(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func createButtonOnPress(_ sender: Any) {
        guard let className = classNameTextField.text, className.count > 4 else {
            dismiss()
            warningDelegate?.warningAction(warning: "Class name should be longer than 4 characters!")
            return
        }
        guard let classPassword = passwordTextField.text, classPassword.count > 4 else {
            dismiss()
            warningDelegate?.warningAction(warning: "Password should be longer than 4 characters!")
            return
        }
    
        if TeacherClassDataSource.getInstance().checkClassOccurrence(name: classNameTextField.text!){
            dismiss()
            warningDelegate?.warningAction(warning: "Class name should be different!")
        }else {
            TeacherClassDataSource.getInstance().writeClass(className: className, classPassword: classPassword)
            dismiss()
        }
    }
    
    private func dismiss(){
        classNameTextField.text = ""
        passwordTextField.text = ""
        self.dismiss(animated: true, completion: nil)
    }
}
