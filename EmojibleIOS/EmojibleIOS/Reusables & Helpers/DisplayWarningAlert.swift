//
//  WrongInputFormatAlert.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 15.12.2020.
//

import UIKit

class DisplayWarningAlert: CustomAlertViewController{
    let warningTitle = UILabel()
    let warningLabel = UILabel()
    let dismissButton = UIButton()
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    func configureView(){
        self.alertView.backgroundColor = #colorLiteral(red: 0.9277921319, green: 0.927813828, blue: 0.9278021455, alpha: 1)
        self.alertView.cornerRadiusV = 10
        self.alertView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([self.alertView.widthAnchor.constraint(equalToConstant: 400),
                                     self.alertView.heightAnchor.constraint(equalToConstant: 200),
                                     self.alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     self.alertView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.2 * self.view.frame.height)])
        
        
        warningTitle.text = "WARNING!"
        warningTitle.textColor = .black
        warningTitle.font = .systemFont(ofSize: 17)
        warningTitle.translatesAutoresizingMaskIntoConstraints = false
        warningTitle.textAlignment = .center
        warningTitle.numberOfLines = 0
        
        warningLabel.textColor = .black
        warningLabel.font = .systemFont(ofSize: 17)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.textAlignment = .center
        warningLabel.numberOfLines = 0
        
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.titleLabel?.font = .systemFont(ofSize: 17)
        dismissButton.setTitleColor(#colorLiteral(red: 0.007333596703, green: 0.2443790138, blue: 0.5489466786, alpha: 1), for: .normal)
        dismissButton.titleLabel?.textAlignment = .center
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.sizeToFit()
        dismissButton.addTarget(self, action: #selector(dismissButtonOnPress), for: .touchUpInside)

        
        self.alertView.addSubview(warningTitle)
        self.alertView.addSubview(warningLabel)
        self.alertView.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([self.warningTitle.topAnchor.constraint(equalTo: self.alertView.topAnchor, constant: 5),
                                     self.warningTitle.centerXAnchor.constraint(equalTo: self.alertView.centerXAnchor),
                                     self.warningTitle.widthAnchor.constraint(equalToConstant: 100),
                                     self.warningTitle.heightAnchor.constraint(equalToConstant: 50)])

        NSLayoutConstraint.activate([self.warningLabel.topAnchor.constraint(equalTo: self.warningTitle.bottomAnchor, constant: 5),
                                     self.warningLabel.centerXAnchor.constraint(equalTo: self.alertView.centerXAnchor),
                                     self.warningLabel.widthAnchor.constraint(equalToConstant: 350)])
        
        NSLayoutConstraint.activate([self.dismissButton.topAnchor.constraint(equalTo: self.warningLabel.bottomAnchor, constant: 5),
                                     self.dismissButton.bottomAnchor.constraint(equalTo: self.alertView.bottomAnchor, constant: 5),
                                     self.dismissButton.centerXAnchor.constraint(equalTo: self.alertView.centerXAnchor),
                                     self.dismissButton.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    
    func configureWarning(text: String) {
        warningLabel.text = text
    }
    
    @objc func dismissButtonOnPress(_ sender: Any) {
        dismiss()
    }
    
    private func dismiss(){
        self.warningLabel.text = nil
        self.dismiss(animated: true, completion: nil)
    }
}
