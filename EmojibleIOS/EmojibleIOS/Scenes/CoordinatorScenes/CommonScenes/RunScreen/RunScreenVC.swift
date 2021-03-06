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
    var errorMessage:String!
    var tap: UITapGestureRecognizer!
    var isBeingTouched:Bool = false
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var terminateButton: UIButton!
    
    override func viewDidLoad(){
        configureLanguage()
        self.navigationController?.navigationBar.isHidden = true
        tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
    }
    func configureLanguage(){
        enterButton.setTitle("Enter".localized(), for: .normal)
        terminateButton.setTitle("Terminate".localized(), for: .normal)
        inputTextField.placeholder = "Enter input".localized()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        do{
            guard let coordinator = coordinator as? RunCodeCoordinator else { return }
            runningCode = coordinator.runningCode
            outputLabel.isHidden = true
            inputTextField.isHidden = true
            view.removeGestureRecognizer(tap)
            enterButton.isHidden = true
            try Interpreter.getInstance().runCode(code: runningCode)
        }catch ParserErrors.EndOfLineExpected{
            showErrorMessageAndDismiss("End of Line Expected".localized())
        }catch ParserErrors.UnexpectedToken (let token, let expected){
            var warning_string = "Unexpected Token: ".localized()
            warning_string += token.type.description
            warning_string += ". Expected: ".localized()
            warning_string += expected
            showErrorMessageAndDismiss(warning_string)
        }catch LexerErrors.UnknownCharacter(let lineNumber, let char){
            showErrorMessageAndDismiss("Unknown Character: ".localized() + char + " at line: ".localized() + lineNumber)
        }catch{
            showErrorMessageAndDismiss("Unknown Error occured".localized())
            
        }
       
    }
    
    @objc func showErrorMessageAndDismiss(_ message: String?) {
        var msg: String
        if message == nil{
            msg = self.errorMessage
        }else{
            msg = message!
        }
        terminateButton.isHidden = true
        self.view.backgroundColor = UIColor.black
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){_ in 
            AppCoordinator.getInstance().terminateCode()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    
    @objc func changeLabelText(){
        outputLabel.isHidden = false
        outputLabel.text = outText
        outputLabel.textColor = UIColor.black
    }
    
    @objc func numericInputRequested(){
        inputTextField.isHidden = false
        view.addGestureRecognizer(tap)
        enterButton.isHidden = false
        inputTextField.keyboardType = .decimalPad
    }
    
    @objc func textInputRequested(){
        inputTextField.isHidden = false
        view.addGestureRecognizer(tap)
        enterButton.isHidden = false
        inputTextField.keyboardType = .default
    }
    
    @objc func changeBackgroundColor(){
        let colorDict = ["Red":UIColor.red,"Green":UIColor.green,"Blue":UIColor.blue,"Yellow":UIColor.yellow]
        self.view.backgroundColor = colorDict[backgroundColor]
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Interpreter.getInstance().finish()
        inputTextField.text = ""
        self.view.backgroundColor = UIColor.white
        terminateButton.isHidden = false
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

extension RunScreenVC{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            isBeingTouched = true
        }

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            isBeingTouched = false
        }
    }

}
