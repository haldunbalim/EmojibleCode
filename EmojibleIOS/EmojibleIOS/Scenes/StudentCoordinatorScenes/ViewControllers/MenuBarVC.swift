//
//  File.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 18.11.2020.
//

import UIKit

class MenuBarVC: UIViewController, Coordinated {
    var coordinator: Coordinator?
    
    var selectedIndex: Int = 0
    var previousIndex : Int?
    
    @IBOutlet var tabs: [UIButton]!
    
    override func viewDidLoad() {
        tabPressed(sender: tabs[selectedIndex])
    }
    
    
    @IBAction func tabPressed(sender: UIButton){
        previousIndex = selectedIndex
        selectedIndex = sender.tag
        tabs[previousIndex!].isSelected = false
        sender.isSelected = true
    }
    
    
}

