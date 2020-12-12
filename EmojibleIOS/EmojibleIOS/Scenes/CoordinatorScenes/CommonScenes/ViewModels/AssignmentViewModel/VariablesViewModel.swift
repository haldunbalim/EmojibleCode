//
//  VariablesViewModel.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 23.11.2020.
//

import UIKit

class VariablesViewModel: UICollectionViewCell{
    
    var variableDelegate: AssignmentTabVariableSectionAction?
    
    @IBOutlet weak var emojiButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
 
    func configureView (emoji: String) {
        emojiButton.setTitle(emoji, for: .normal)
        emojiButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    @IBAction func emojiPressed(_ sender: UIButton) {
        variableDelegate?.variableAction(emoji: sender.currentTitle!)
    }
}
