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
        self.navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
        self.title = "Settings"
        configureTableView()
        configureRemoveAlert()
        NotificationCenter.default.addObserver(self, selector: #selector(notify), name: .userModelChanged, object: nil)
    }
    
    @objc func notify(_ notification: NSNotification){
        tableView.reloadData()
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SettingsViewModel", bundle: .main), forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = .white
        tableView.backgroundColor = .white

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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SettingsViewModel{
       
            if indexPath.row == 0{
                UserDataSource.getInstance().getCurrentUserInfo(){ userModel in
                    guard let userModel = userModel else {return}
                    cell.configureUserNameCell(name: userModel.name, surname: userModel.surname)
                }
            }else if indexPath.row == 1{
                UserDataSource.getInstance().getCurrentUserInfo(){ userModel in
                    guard let userModel = userModel else {return}
                    let calendar = Calendar.current
                    let ageComponents = calendar.dateComponents([.year], from: userModel.birthDate, to: Date())
                    cell.configureAgeCell(age: String(ageComponents.year!))
                }
            }else if indexPath.row == 2{
                UserDataSource.getInstance().getCurrentUserInfo(){ userModel in
                    guard let userModel = userModel else {return}
                    if userModel is StudentModel {
                        cell.configureAccountCell(accountType:"Student".localized())
                    }else {
                        cell.configureAccountCell(accountType:"Teacher".localized())
                    }
                }
            }else if indexPath.row == 3{
                cell.changePasswordDelegate = self
                cell.configureChangePasswordButton()
            }
            else if indexPath.row == 4{
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
    func changePasswordAction() {
        (self.coordinator as! SettingsCoordinator).openScreen(screenName: .ResetPasswordScreen)
    }
    
    func logoutAction() {
        self.removeAlert.presentOver(viewController: self)
        self.removeAlert.deleteButton.setTitleColor(.red, for: .normal)
        self.removeAlert.deleteButton.setTitle("Logout".localized(), for: .normal)
    }
}
