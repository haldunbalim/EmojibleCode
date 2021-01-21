//
//  RunScreenVC.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 4.12.2020.
//
import Foundation
import UIKit

class RunScreenVC:UIViewController, Coordinated{
    var coordinator: Coordinator?
    var notificationCenter = NotificationCenter.default
    
    var runningCode:String!
    var input:String!
    var backgroundColor:String!
    var outText:String!
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var terminateButton: UIButton!
    
    override func viewDidLoad(){
        configureLanguage()
        self.navigationController?.navigationBar.isHidden = true
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    func configureLanguage(){
        enterButton.setTitle("Enter".localized(), for: .normal)
        terminateButton.setTitle("Terminate".localized(), for: .normal)
        inputTextField.placeholder = "Enter input".localized()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let coordinator = coordinator as? RunCodeCoordinator else { return }
        
        runningCode = coordinator.runningCode
        Interpreter.getInstance().runCode(code: runningCode)
        outputLabel.isHidden = true
        inputTextField.isHidden = true
        enterButton.isHidden = true
    }
    
    @objc func changeLabelText(){
        outputLabel.isHidden = false
        outputLabel.text = outText
    }
    
    @objc func numericInputRequested(){
        inputTextField.isHidden = false
        enterButton.isHidden = false
        inputTextField.keyboardType = .decimalPad
    }
    
    @objc func textInputRequested(){
        inputTextField.isHidden = false
        enterButton.isHidden = false
        inputTextField.keyboardType = .default
    }
    
    @objc func changeBackgroundColor(){
        let colorDict = ["Red":UIColor.red,"Green":UIColor.green,"Blue":UIColor.blue]
        self.view.backgroundColor = colorDict[backgroundColor]
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Interpreter.getInstance().finish()
        inputTextField.text = ""
        self.view.backgroundColor = UIColor.white
    }
    
    @IBAction func terminateOnPress(_ sender:UIButton){
        AppCoordinator.getInstance().terminateCode()
    }
    
    @IBAction func enterButtonOnPress(_ sender:UIButton){
        guard let text = inputTextField.text else { return }
        input = text
        Interpreter.getInstance().inputSemaphore.signal()
    }
}
