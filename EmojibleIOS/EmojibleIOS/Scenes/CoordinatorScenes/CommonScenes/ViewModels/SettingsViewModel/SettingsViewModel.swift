//
//  SettingsCellViewModel.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 13.12.2020.
//

import UIKit

class SettingsViewModel: UITableViewCell{
    let label = UILabel()
    
    let logoutButton = UIButton()
    let changePasswordButton = UIButton()
    let languageButton = UIButton()
    let enrollClassButton = UIButton()
    
    var logoutDelegate: SettingsTabButtonActions?
    var changePasswordDelegate: SettingsTabButtonActions?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureLabel(text: String){
        label.text = text
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        self.addSubview(label)
        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: self.topAnchor),
                                    label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                    label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                                    label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10)])
    }
    
    func configureAccountCell(accountType: String){
        configureLabel(text: "Account type".localized() + ": \(accountType)")
    }
    
    func configureUserNameCell(name: String, surname:String){
        configureLabel(text: "User name".localized() + ": \(name) \(surname)")
    }
    func configureAgeCell(age: String){
        configureLabel(text: "User age".localized() + ": \(age)")
    }
    
    func configureLogOutButton(){
        logoutButton.setTitle("Logout".localized(), for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 17)
        logoutButton.setTitleColor(.red, for: .normal)
        logoutButton.titleLabel?.textAlignment = .center
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        self.addSubview(logoutButton)
        NSLayoutConstraint.activate([logoutButton.topAnchor.constraint(equalTo: self.topAnchor),
                                     logoutButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     logoutButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                                     logoutButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10)])
    }
     
    @objc func logoutButtonAction(){
        self.logoutDelegate?.logoutAction()
    }
    
    func configureChangePasswordButton(){
        changePasswordButton.setTitle("Change Password".localized(), for: .normal)
        changePasswordButton.titleLabel?.font = .systemFont(ofSize: 17)
        changePasswordButton.setTitleColor(#colorLiteral(red: 0.007333596703, green: 0.2443790138, blue: 0.5489466786, alpha: 1), for: .normal)
        changePasswordButton.titleLabel?.textAlignment = .center
        changePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        changePasswordButton.addTarget(self, action: #selector(changePasswordButtonAction), for: .touchUpInside)
        self.addSubview(changePasswordButton)
        NSLayoutConstraint.activate([changePasswordButton.topAnchor.constraint(equalTo: self.topAnchor),
                                     changePasswordButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     changePasswordButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                                     changePasswordButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10)])
    }
     
    @objc func changePasswordButtonAction(){
        self.changePasswordDelegate?.changePasswordAction()
    }
    
    func configureLanguageButton(){
        languageButton.setTitle("Change Language", for: .normal)
        languageButton.titleLabel?.font = .systemFont(ofSize: 17)
        languageButton.setTitleColor(#colorLiteral(red: 0.007333596703, green: 0.2443790138, blue: 0.5489466786, alpha: 1), for: .normal)
        languageButton.titleLabel?.textAlignment = .center
        languageButton.translatesAutoresizingMaskIntoConstraints = false
        languageButton.addTarget(self, action: #selector(languageButtonAction), for: .touchUpInside)
        self.addSubview(languageButton)
        NSLayoutConstraint.activate([languageButton.topAnchor.constraint(equalTo: self.topAnchor),
                                     languageButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     languageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                                     languageButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10)])
    }
     
    @objc func languageButtonAction(){
        //TO DO
    }
    
    func configureEnrollClassButton(){
        enrollClassButton.setTitle("Enroll in a class", for: .normal)
        enrollClassButton.titleLabel?.font = .systemFont(ofSize: 17)
        enrollClassButton.setTitleColor(#colorLiteral(red: 0.007333596703, green: 0.2443790138, blue: 0.5489466786, alpha: 1), for: .normal)
        enrollClassButton.titleLabel?.textAlignment = .center
        enrollClassButton.translatesAutoresizingMaskIntoConstraints = false
        enrollClassButton.addTarget(self, action: #selector(enrollClassButtonAction), for: .touchUpInside)
        self.addSubview(enrollClassButton)
        NSLayoutConstraint.activate([enrollClassButton.topAnchor.constraint(equalTo: self.topAnchor),
                                     enrollClassButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     enrollClassButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                                     enrollClassButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10)])
    }
     
    @objc func enrollClassButtonAction(){
    }
    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
     */
}
