//
//  ProgramNewCodeViewModel.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 23.11.2020.
//

import UIKit

class ProgramNewCodeViewModel: UICollectionViewCell {
    
    var newCodeDelegate: ProgramTabButtonAction?
    
    @IBOutlet weak var newCodeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newCodeButton.backgroundColor = #colorLiteral(red: 0.3482096195, green: 0.7082406878, blue: 0.8458661437, alpha: 1)
        newCodeButton.tintColor = #colorLiteral(red: 0.007333596703, green: 0.2443790138, blue: 0.5489466786, alpha: 1)
    }

    func configureView () {
        newCodeDelegate?.newCodeAction()
    }

     @IBAction func newCodePressed(_ sender: UIButton) {
        newCodeDelegate?.newCodeAction()
     }


}
