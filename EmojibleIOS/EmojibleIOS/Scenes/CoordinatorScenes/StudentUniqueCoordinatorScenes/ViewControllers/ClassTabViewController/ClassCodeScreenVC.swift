//
//  ClassCodeScreenVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 21.12.2020.
//

import Foundation
import UIKit

class ClassCodeScreenVC: UIViewController, Coordinated{
    var coordinator: Coordinator?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tutorialTextView: UITextView!
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureTextView()
        configureTitleLabel()
        configureLanguage()
        self.navigationController?.navigationBar.isHidden = true
    }
    func configureLanguage(){
        backButton.setTitle("Class".localized().uppercased(), for: .normal)
        runButton.setTitle("Run".localized().uppercased(), for: .normal)
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
        tutorialTextView.text = (self.coordinator as! ClassCoordinator).tutorialCode
    }
    func configureTitleLabel(){
        titleLabel.text = (self.coordinator as! ClassCoordinator).tutorialTitle
    }
    
    @IBAction func runPressed(_ sender: UIButton) {
        let code = (self.coordinator as! ClassCoordinator).tutorialCode
        AppCoordinator.getInstance().runCode(code: code!)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        (self.coordinator as! ClassCoordinator).pop()
    }
}
