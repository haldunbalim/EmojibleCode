//
//  TutorialDataSource.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import Foundation

class TutorialDataSource {
     
    // Dummy test method
    public func getTutorialInfo() -> [Tutorial] {
        return [Tutorial(color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), level: "Beginner", tutorialNumber: "Tutorial 1"),
                Tutorial(color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), level: "Beginner", tutorialNumber: "Tutorial 2"),
                Tutorial(color: #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), level: "Intermediate", tutorialNumber: "Tutorial 3"),
                Tutorial(color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), level: "Advance", tutorialNumber: "Tutorial 4")
        ]
    }
}




