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
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func configureLanguage(){
        classNameTextField.placeholder = "Class name".localized()
        passwordTextField.placeholder = "Class password".localized()
        cancelButton.setTitle("Cancel".localized(), for: .normal)
        createButton.setTitle("Create".localized(), for: .normal)
    }
    
    @IBAction func cancelButtonOnPress(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func createButtonOnPress(_ sender: Any) {
        guard let className = classNameTextField.text, className.count > 0 else {
            dismiss()
            warningDelegate?.warningAction(warning: "Class name cannot be empty".localized())
            return
        }
        guard let classPassword = passwordTextField.text, classPassword.count > 0 else {
            dismiss()
            warningDelegate?.warningAction(warning: "Class password cannot be empty".localized())
            return
        }
    
        if TeacherClassDataSource.getInstance().checkClassOccurrence(name: classNameTextField.text!){
            dismiss()
            warningDelegate?.warningAction(warning: "This class already exists".localized() + "!\n" + "Class name should be different".localized())
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
