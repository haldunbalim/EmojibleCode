//
//  TeacherProgramViewModel.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 12.12.2020.
//

import UIKit

class TeacherTutorialViewModel: UICollectionViewCell {
    var editDelegate: TeacherTutorialTabButtonAction?
    var runDelegate: TeacherTutorialTabButtonAction?
    var trashDelegate: TeacherTutorialTabButtonAction?

    
    var codeModel: CodeModel?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var runButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = #colorLiteral(red: 0.007333596703, green: 0.2443790138, blue: 0.5489466786, alpha: 1)
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        if let model = self.codeModel {
            editDelegate?.editAction(tutorialModel: model)
        }
    }
    
    @IBAction func runPressed(_ sender: UIButton) {
        runDelegate?.runAction(code: self.codeModel!.code)
    }
    
    @IBAction func trashPressed(_ sender: UIButton) {
        if let model = self.codeModel {
            trashDelegate?.trashAction(tutorialModel: model)
        }
    }
    
    func configureView (codeModel: CodeModel) {
        self.codeModel = codeModel
        nameLabel.text = codeModel.name
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.adjustsFontSizeToFitWidth = true
        codeLabel.text = removeComments(codeModel.code)
        editButton.setTitle("Edit".localized(), for: .normal)
        runButton.setTitle("Run".localized(), for: .normal)
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
