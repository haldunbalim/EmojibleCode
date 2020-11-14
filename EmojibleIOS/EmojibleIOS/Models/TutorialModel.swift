//
//  Tutorial.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import UIKit

struct TutorialModel {
    var color: UIColor
    var level: String
    var tutorialNumber: String
    
    init(color: UIColor, level: String, tutorialNumber:String) {
        self.color = color
        self.level = level
        self.tutorialNumber = tutorialNumber
    }
}
