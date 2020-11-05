//
//  TutorialViewCell.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import UIKit

class TutorialViewCell: UICollectionViewCell {
    @IBOutlet weak var tutorialLevelLabel: UILabel!
    @IBOutlet weak var tutorialNumberLabel: UILabel!

    func configureView(tutorial: Tutorial){
        self.backgroundColor = tutorial.color
        tutorialLevelLabel.text = tutorial.level
        tutorialNumberLabel.text = tutorial.tutorial_number
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
