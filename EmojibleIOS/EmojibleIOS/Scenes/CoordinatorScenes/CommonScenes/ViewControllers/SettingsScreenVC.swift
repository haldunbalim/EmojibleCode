//
//  SettingsScreenVC.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
import UIKit

private let reuseIdentifier = "SettingsScreenCell"

class SettingsScreenVC: UIViewController, Coordinated{
    var coordinator: Coordinator?
    
    @IBOutlet weak var tableView: UITableView!
    
    var removeAlert: RemoveAlert!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.navigationController?.navigationBar.isHidden = true
        configureTableView()
        configureRemoveAlert()
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SettingsViewModel", bundle: .main), forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = UIColor.white

        NSLayoutConstraint.activate([tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH + 20)])
    }
    
    func configureRemoveAlert(){
        removeAlert = RemoveAlert()
        removeAlert.delegate = self
    }
}

extension SettingsScreenVC:UITableViewDelegate{}

extension SettingsScreenVC:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SettingsViewModel{
            if indexPath.row == 0{
                cell.configureUserNameCell(name: "Furkan", surname: "Yakal")
            }else if indexPath.row == 1{
                cell.configureAgeCell(age: "23")
            }else if indexPath.row == 2{
                cell.configureAccountCell(accountType: "Student")
            }else if indexPath.row == 3{
                cell.configureLanguageButton()
            }else if indexPath.row == 4{
                cell.configureChangePasswordButton()
            }
            else if indexPath.row == 5{
                cell.logoutDelegate = self
                cell.configureLogOutButton()
            }
            else {
                cell.configureLabel(text: "Settings Cell")
            }
            return cell
            
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
 

extension SettingsScreenVC:SettingsTabButtonActions{
    func logoutAction() {
        self.removeAlert.presentOver(viewController: self)
        self.removeAlert.deleteButton.setTitleColor(.red, for: .normal)
        self.removeAlert.deleteButton.setTitle("LogOut", for: .normal)
    }
}
