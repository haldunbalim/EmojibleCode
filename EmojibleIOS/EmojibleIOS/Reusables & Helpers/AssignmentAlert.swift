//
//  AssignmentAlert.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 27.11.2020.
//

import UIKit

class AssignmentAlert: CustomAlertViewController{
    
    var textDelegata: AssignmentPopUpAlert?
    var voiceDelegate: AssignmentPopUpAlert?
    var funcDelegate: AssignmentPopUpAlert?
    
    @IBOutlet weak var emojiLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonOnPress(_ sender: Any) {
        dismiss()
    }

    @IBAction func textButtonOnPress(_ sender: Any) {
        dismiss()
        textDelegata?.textButtonPressed()
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

