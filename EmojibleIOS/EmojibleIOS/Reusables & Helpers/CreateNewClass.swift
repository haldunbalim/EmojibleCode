//
//  CreateNewClass.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 15.12.2020.
//

import UIKit

class CreateNewClassAlert: CustomAlertViewController{
    
    @IBOutlet weak var classNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonOnPress(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func createButtonOnPress(_ sender: Any) {
        dismiss()
    }
    
    private func dismiss(){
        classNameTextField.text = ""
        passwordTextField.text = ""
        self.dismiss(animated: true, completion: nil)
    }
}
