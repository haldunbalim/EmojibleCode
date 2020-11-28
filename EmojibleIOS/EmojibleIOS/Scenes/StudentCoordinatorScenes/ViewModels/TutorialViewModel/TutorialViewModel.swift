//
//  CollectionViewCell.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import UIKit

class TutorialViewModel: UICollectionViewCell {
    var viewDelegate: TutorialTabButtonAction?
    var runDelegate: TutorialTabButtonAction?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = #colorLiteral(red: 0.7525274158, green: 0.8178007007, blue: 0.9784051776, alpha: 1)
    }
    
    func configureView (codeModel: CodeModel) {
        nameLabel.text = codeModel.name
        codeLabel.text = removeComments(codeModel.code)
    }
    
    @IBAction func viewPressed(_ sender: UIButton) {
        viewDelegate?.viewAction(title: nameLabel.text ?? "", code: codeLabel.text ?? "")
    }
    
    @IBAction func runPressed(_ sender: UIButton) {
        runDelegate?.runAction()
    }
    
    private func removeComments(_ code:String) -> String{
        var removed = ""
        for line in code.components(separatedBy: "\n"){
            if let range = line.range(of: TokenType.COMMENT.rawValue) {
                removed += line[..<range.lowerBound]
            }
            else {
                removed += line
            }
            removed += "\n"
        }
        return removed
    }
    
}
