//
//  CollectionViewCell.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import UIKit

class TutorialScreenCell: UICollectionViewCell {
    @IBOutlet weak var tutorialLevelLabel: UILabel!
    @IBOutlet weak var tutorialNumberLabel: UILabel!
    
    func configure (tutorial: TutorialModel) {
        self.backgroundColor = tutorial.color
        print(tutorial)
        
        //tutorialLevelLabel.text = tutorial.level
        //tutorialNumberLabel.text = tutorial.tutorialNumber
    }
}
