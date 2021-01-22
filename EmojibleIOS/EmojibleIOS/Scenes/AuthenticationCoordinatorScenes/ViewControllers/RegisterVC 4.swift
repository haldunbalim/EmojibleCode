//
//  RegisterScreenVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import Foundation
import UIKit

class RegisterVC: UIViewController, Coordinated, UIViewControllerWithAlerts{
    
    var pleaseWaitAlert: UIAlertController?
    var coordinator: Coordinator?
    let userTypeOptions = ["Student","Teacher"]
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var birthDatePickerToolbar: UIToolbar!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        configureViews()
        configureBirthDatePicker()
        guard let coordinator = coordinator as? AuthenticationCoordinator else { return }
    }
    
    func configureViews(){
        NSLayoutConstraint.activate([emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
        NSLayoutConstraint.activate([passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
        NSLayoutConstraint.activate([nameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
        NSLayoutConstraint.activate([surnameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
        NSLayoutConstraint.activate([birthDateTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])

        NSLayoutConstraint.activate([birthDatePicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH + 10)])
        NSLayoutConstraint.activate([birthDatePickerToolbar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH + 10)])
        
        
        NSLayoutConstraint.activate([backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH)])
    }
    
    
    func configureBirthDatePicker(){
        birthDatePickerToolbar.isHidden = true
        birthDatePicker.isHidden = true
        birthDateTextField.addTarget(self, action: #selector(birthDateTextFieldTouched), for: .touchDown)
        birthDateTextField.addTarget(self, action: #selector(birthDateTextEditingEnded), for: .editingDidEnd)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(datePickerToolbarDoneButtonPressed))
        birthDatePickerToolbar.setItems([doneButton], animated: false)
    }
    
    @objc func datePickerToolbarDoneButtonPressed(){
        birthDatePickerToolbar.isHidden = true
        birthDatePicker.isHidden = true
        birthDateTextField.endEditing(true)
        birthDateTextField.text = CustomDateFormatter.getInstance().getStringFromDate(from:birthDatePicker.date)
    }
    
    @objc func birthDateTextFieldTouched(){
        birthDatePickerToolbar.isHidden = false
        birthDatePicker.isHidden = false
    }
    @objc func birthDateTextEditingEnded(){
        birthDatePickerToolbar.isHidden = true
        birthDatePicker.isHidden = true
        birthDateTextField.text = CustomDateFormatter.getInstance().getStringFromDate(from:birthDatePicker.date)
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        resetFields()
        (self.coordinator as! AuthenticationCoordinator).pop()
    }
    func resetFields(){
        emailTextField.text = ""
        passwordTextField.text = ""
        nameTextField.text = ""
        surnameTextField.text = ""
        birthDateTextField.text = ""
        birthDatePicker.calendar = .current
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, email != "" else {
            showMessagePrompt("E-mail cannot be empty", vcToBePresented: self)
            return
        }
        
        guard let password = passwordTextField.text, password != "" else {
            showMessagePrompt("Password cannot be empty", vcToBePresented: self)
            return
        }
        
        guard let name = nameTextField.text, name != "" else {
            showMessagePrompt("Name cannot be empty", vcToBePresented: self)
            return
        }
        
        guard let surname = surnameTextField.text, surname != "" else {
            showMessagePrompt("Surname cannot be empty", vcToBePresented: self)
            return
        }
        
        guard let birthDate = birthDateTextField.text, birthDate != "" else {
            showMessagePrompt("Birth Date cannot be empty", vcToBePresented: self)
            return
        }
        
        self.showSpinner(){
            AuthenticationManager.getInstance().createUserWithEmailAndPassword(email: email, password: password){[unowned self] error in
                if let error = error {
                    self.hideSpinner()
                    showMessagePrompt(error, vcToBePresented: self)
                }else{
                    let birthdate = CustomDateFormatter.getInstance().getDateFromString(from: birthDate)
                    guard let coordinator = coordinator as? AuthenticationCoordinator else { return }
                    UserDataSource.getInstance().writeUserData(user:UserFactory.getInstance().create(userType:coordinator.registeringUserType!,email:email,name:name,surname:surname,birthDate:birthdate))
                    AuthenticationManager.getInstance().signInWithEmailAndPassword(email: email, password:password){[unowned self] error in
                        if let error = error {
                            self.hideSpinner()
                            showMessagePrompt(error, vcToBePresented: self)
                        }else{
                            resetFields()
                            AuthenticationCoordinator.getInstance().reset()
                            self.hideSpinner()
                            
                        }
                    }
                }
            }
        }
    }
    
    
}
