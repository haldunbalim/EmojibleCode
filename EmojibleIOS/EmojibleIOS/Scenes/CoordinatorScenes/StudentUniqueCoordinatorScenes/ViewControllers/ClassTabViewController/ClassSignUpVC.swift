//
//  ClassSignUpVC.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
import UIKit

class ClassSignUpVC:UIViewController, Coordinated, UIViewControllerWithAlerts{
    var pleaseWaitAlert: UIAlertController?
    var coordinator: Coordinator?

    @IBOutlet weak var enrollLabel: UILabel!
    
    @IBOutlet weak var enrollButton: UIButton!
    @IBOutlet weak var classCodeTextField: UITextField!
    @IBOutlet weak var classPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureLanguage()
        self.navigationController?.navigationBar.isHidden = true
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func configureLanguage(){
        enrollLabel.text = "Enroll in a class".localized()
        classCodeTextField.placeholder = "Class id".localized()
        classPasswordTextField.placeholder = "Class password".localized()
        enrollButton.setTitle("Enroll".localized(), for: .normal)
    }
    
    func configureViews(){
        NSLayoutConstraint.activate([classPasswordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
        NSLayoutConstraint.activate([classCodeTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
        NSLayoutConstraint.activate([enrollLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        guard let classCode = classCodeTextField.text, classCode != "" else {
            showMessagePrompt("Class id cannot be empty".localized(), vcToBePresented: self)
            return
        }
        
        guard let classPassword = classPasswordTextField.text, classPassword != "" else {
            showMessagePrompt("Class password cannot be empty".localized(), vcToBePresented: self)
            return
        }
        self.showSpinner(){
            TeacherClassDataSource.getInstance().addStudent(classId: classCode, classPassword: classPassword){[unowned self] error in
                if let error = error {
                    self.hideSpinner()
                    showMessagePrompt(error, vcToBePresented: self)
                }else{
                    self.hideSpinner()
                }
            }
        }
    }
}
