//
//  ForgetPasswordVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import Foundation
import UIKit

class ForgetPasswordVC: UIViewController, Coordinated{
    var coordinator: Coordinator?
    
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
    }
}
