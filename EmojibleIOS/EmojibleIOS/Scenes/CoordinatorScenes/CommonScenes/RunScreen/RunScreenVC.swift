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
    var isBeingTouched:Bool = false
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        do{
            guard let coordinator = coordinator as? RunCodeCoordinator else { return }
            runningCode = coordinator.runningCode
            outputLabel.isHidden = true
            inputTextField.isHidden = true
            enterButton.isHidden = true
            try Interpreter.getInstance().runCode(code: runningCode)
        }catch ParserErrors.EndOfLineExpected{
            showErrorMessageAndDismiss("End of Line Expected")
        }catch ParserErrors.UnexpectedToken (let token){
            showErrorMessageAndDismiss("Unexpected Token: \(token.type.description) at Line: \(token.lineNumber)")
        }catch LexerErrors.UnknownCharacter(let lineNumber, let char){
            showErrorMessageAndDismiss("Unknown Character: \(char) at line: \(lineNumber)")
        }catch{
            showErrorMessageAndDismiss("Unknown Error occured")
            
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
