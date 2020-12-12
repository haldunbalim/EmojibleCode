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
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad(){
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let coordinator = coordinator as? RunCodeCoordinator else { return }
        runningCode = coordinator.runningCode
        Interpreter.getInstance().runCode(code: runningCode)
        outputLabel.isHidden = true
        inputTextField.isHidden = true
        enterButton.isHidden = true

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
        if let _ = self.coordinator?.parentCoordinator as? CommonCoordinator {
            CommonCoordinator.getInstance().terminateCode()
        }else if let _ = self.coordinator?.parentCoordinator as? StudentCoordinator {
            StudentCoordinator.getInstance().terminateCode()
        }else if let _ = self.coordinator?.parentCoordinator as? TeacherCoordinator{
            TeacherCoordinator.getInstance().terminateCode()
        }
    }
    
    @IBAction func enterButtonOnPress(_ sender:UIButton){
        guard let text = inputTextField.text else { return }
        input = text
        Interpreter.getInstance().inputSemaphore.signal()
    }
}
