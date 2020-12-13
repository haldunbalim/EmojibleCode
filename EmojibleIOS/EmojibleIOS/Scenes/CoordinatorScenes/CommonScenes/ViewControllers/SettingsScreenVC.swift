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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.navigationController?.navigationBar.isHidden = true
        configureTableView()
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SettingsViewModel", bundle: .main), forCellReuseIdentifier: reuseIdentifier)
        
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = UIColor.white

        NSLayoutConstraint.activate([tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH + 20)])
    }
}

extension SettingsScreenVC:UITableViewDelegate{
}

extension SettingsScreenVC:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SettingsViewModel{
        
            cell.setLabel(text: "Settings")
            return cell
            
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
 
