//
//  ForgetPasswordVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import Foundation
import UIKit

class ForgetPasswordVC: UIViewController, Coordinated{
    var coordinator: Coordinator?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var getLinkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        configureViews()
    }
    
    func configureViews(){
        NSLayoutConstraint.activate([emailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
        NSLayoutConstraint.activate([getLinkButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
        NSLayoutConstraint.activate([backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH)])
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        emailTextField.text = ""
        (self.coordinator as! AuthenticationCoordinator).pop()
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
    }
}
