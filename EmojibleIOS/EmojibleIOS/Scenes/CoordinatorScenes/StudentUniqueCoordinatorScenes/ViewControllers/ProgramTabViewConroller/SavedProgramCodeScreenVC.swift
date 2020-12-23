//
//  SavedProgramCodeScreenVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 26.11.2020.
//

import UIKit


class SavedProgramCodeScreenVC: UIViewController, Coordinated {
    var coordinator: Coordinator?
    var programModel: CodeModel?

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var savedProgramTextView: UITextView!
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        self.navigationController?.navigationBar.isHidden = true
        programModel = (self.coordinator as! ProgramsCoordinator).programModel
        configureViews()
        configureTextView()
        configureTitleLabel()
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
        savedProgramTextView.text = self.programModel?.code
    }
    
    func configureTitleLabel(){
        titleField.text = self.programModel?.name
    }
    
    @IBAction func runPressed(_ sender: UIButton) {
        if titleField.text != self.programModel?.name || savedProgramTextView.text != self.programModel?.code {
            ProgramDataSource.getInstance().editProgram(oldProgram: self.programModel!, newProgram: CodeModel(name: titleField.text!, code: savedProgramTextView.text))
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        (self.coordinator as! ProgramsCoordinator).pop()
    }
}
