//
//  SettingsScreenVC.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
import UIKit

class SettingsScreenVC: UIViewController, Coordinated{
    var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        configureNavigationBar()
    }
    
    func configureNavigationBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}