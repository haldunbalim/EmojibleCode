//
//  AssignmentAlert.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 27.11.2020.
//

import UIKit

class AssignmentAlert: CustomAlertViewController{
    
    var textDelegate: AssignmentPopUpAlert?
    var voiceDelegate: AssignmentPopUpAlert?
    var funcDelegate: AssignmentPopUpAlert?
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var functionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
        
    }
    func configureLanguage(){
        textButton.setTitle("Text".localized(), for: .normal)
        voiceButton.setTitle("Voice".localized(), for: .normal)
        functionButton.setTitle("Function".localized(), for: .normal)
    }
    
    @IBAction func cancelButtonOnPress(_ sender: Any) {
        dismiss()
    }

    @IBAction func textButtonOnPress(_ sender: Any) {
        dismiss()
        textDelegate?.textButtonPressed()
    }
    
    @IBAction func voiceButtonOnPress(_ sender: Any) {
        dismiss()
        voiceDelegate?.voiceButtonPressed()
    }
    
    @IBAction func functionButtonOnPress(_ sender: Any) {
        dismiss()
        funcDelegate?.funcButtonPressed()
    }

    private func dismiss(){
        emojiLabel.text = ""
        self.dismiss(animated: true, completion: nil)
    }
}

