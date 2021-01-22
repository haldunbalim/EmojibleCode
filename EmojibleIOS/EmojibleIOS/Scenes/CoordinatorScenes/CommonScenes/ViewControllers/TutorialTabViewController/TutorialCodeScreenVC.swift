//
//  TutorialCellVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 26.11.2020.
//

import UIKit


class TutorialCodeScreenVC: UIViewController, Coordinated {
    var coordinator: Coordinator? 

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tutorialTextView: UITextView!
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        configureLanguage()
        configureViews()
        configureTextView()
        configureTitleLabel()
        configureLanguage()
    }
    func configureLanguage(){
        runButton.setTitle("Run".localized().uppercased(), for: .normal)
        backButton.setTitle("TUTORIALS".localized(), for: .normal)
    }
    func configureViews(){
        NSLayoutConstraint.activate([
            tutorialTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH + 10)])
        NSLayoutConstraint.activate([
            runButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH + 10)
        ])
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH)])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: Constants.TAB_BAR_WIDTH/2)])
    }
    
    func configureTextView(){
        tutorialTextView.isEditable = false
        tutorialTextView.isSelectable = false
        tutorialTextView.text = (self.coordinator as! TutorialsCoordinator).tutorialCode
    }
    func configureTitleLabel(){
        titleLabel.text = (self.coordinator as! TutorialsCoordinator).tutorialTitle
    }
    
    @IBAction func runPressed(_ sender: UIButton) {
        let code = (self.coordinator as! TutorialsCoordinator).tutorialCode
        AppCoordinator.getInstance().runCode(code: code!)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        (self.coordinator as! TutorialsCoordinator).pop()
    }
}
