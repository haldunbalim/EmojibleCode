//
//  CodeViewModel.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 19.11.2020.
//

import UIKit

class ProgramViewModel: UICollectionViewCell {
    
    var editDelegate: ProgramTabButtonAction?
    var runDelegate: ProgramTabButtonAction?
    var trashDelegate: ProgramTabButtonAction?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = #colorLiteral(red: 0.7525274158, green: 0.8178007007, blue: 0.9784051776, alpha: 1)
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        editDelegate?.editAction(title: nameLabel.text ?? "", code: codeLabel.text ?? "")
    }
    
    @IBAction func runPressed(_ sender: UIButton) {
        runDelegate?.runAction()
    }
    
    @IBAction func trashPressed(_ sender: UIButton) {
        trashDelegate?.trashAction()
    }
    
    
    func configureView (codeModel: CodeModel) {
        nameLabel.text = codeModel.name
        codeLabel.text = removeComments(codeModel.code)
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
