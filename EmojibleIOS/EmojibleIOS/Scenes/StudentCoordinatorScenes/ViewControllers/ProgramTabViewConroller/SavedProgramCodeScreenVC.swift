//
//  SavedProgramCodeScreenVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 26.11.2020.
//

import UIKit


class SavedProgramCodeScreenVC: UIViewController, Coordinated {
    var coordinator: Coordinator?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var savedProgramTextView: UITextView!
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
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
        savedProgramTextView.text = (self.coordinator as! ProgramsCoordinator).programCode
    }
    
    func configureTitleLabel(){
        titleLabel.text = (self.coordinator as! ProgramsCoordinator).programTitle
    }
    
    @IBAction func runPressed(_ sender: UIButton) {
    
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        (self.coordinator as! ProgramsCoordinator).pop()
    }
}
