//
//  SavedTutorialScreenVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 12.12.2020.
//

import Foundation
import UIKit

class TeacherSavedTutorialScreenVC: UIViewController, Coordinated {
    var coordinator: Coordinator?
    var tutorialModel: CodeModel?

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var savedProgramTextView: UITextView!
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        tutorialModel = (self.coordinator as! TeacherTutorialCoordinator).tutorialModel
        configureViews()
        configureLanguage()
        configureTextView()
        configureTitleLabel()
    }
    func configureLanguage(){
        backButton.setTitle("TUTORIALS".localized(), for: .normal)
        runButton.setTitle("Run & Share".localized().uppercased(), for: .normal)
        titleField.placeholder = "Enter title...".localized()
    }
    
    func configureViews(){
        NSLayoutConstraint.activate([
            savedProgramTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH + 10)])
        NSLayoutConstraint.activate([
            runButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH + 10)])
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH)])
    }
    
    func configureTextView(){
        savedProgramTextView.text = self.tutorialModel?.code
    }
    
    func configureTitleLabel(){
        titleField.text = self.tutorialModel?.name
    }
    
    @IBAction func runPressed(_ sender: UIButton) {
        if titleField.text != self.tutorialModel?.name || savedProgramTextView.text != self.tutorialModel?.code {
            TeacherTutorialDataSource.getInstance().editTutorial(oldTutorial: self.tutorialModel!, newTutorial: CodeModel(name: titleField.text!, code: savedProgramTextView.text))
        }
        TeacherCoordinator.getInstance().runCode(code: savedProgramTextView.text)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        (self.coordinator as! TeacherTutorialCoordinator).pop()
    }
}
