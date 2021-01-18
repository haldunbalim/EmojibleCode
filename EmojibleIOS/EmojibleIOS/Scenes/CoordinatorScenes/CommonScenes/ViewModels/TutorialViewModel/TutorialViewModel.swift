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
    var codeModel: CodeModel?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var runButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = #colorLiteral(red: 0.007333596703, green: 0.2443790138, blue: 0.5489466786, alpha: 1)
    }
    
    func configureView (codeModel: CodeModel) {
        self.codeModel = codeModel
        nameLabel.text = codeModel.name
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.adjustsFontSizeToFitWidth = true
        
        codeLabel.text = removeComments(codeModel.code)
        viewButton.setTitle("View".localized(), for: .normal)
        runButton.setTitle("Run".localized(), for: .normal)
    }
    
    @IBAction func viewPressed(_ sender: UIButton) {
        if let model = self.codeModel {
            viewDelegate?.viewAction(title: model.name, code: model.code)
        }
    }
    
    @IBAction func runPressed(_ sender: UIButton) {
        runDelegate?.runAction(code: self.codeModel!.code)
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
