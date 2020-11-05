//
//  StudentMainScreenVC.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
import UIKit

class StudentMainScreenVC: UIViewController, Coordinated{
    var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func createCodeButtonPressed(_ sender: UIButton) {
        (self.coordinator as! StudentCoordinator).openScreen(screenName: .CodingScreen)
    }
    @IBAction func tutorialsButtonPressed(_ sender: UIButton) {
        (self.coordinator as! StudentCoordinator).openScreen(screenName: .TutorialScreen)
    }
    
    @IBAction func assignmentsButtonPressed(_ sender: Any) {
        (self.coordinator as! StudentCoordinator).openScreen(screenName: .AssignmentScreen)
    }
    
}
