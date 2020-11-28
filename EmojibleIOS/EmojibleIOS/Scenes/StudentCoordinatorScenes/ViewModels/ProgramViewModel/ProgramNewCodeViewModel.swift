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
        newCodeButton.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0.9607843137, blue: 0.8901960784, alpha: 1)
    }

    func configureView () {
        newCodeDelegate?.newCodeAction()
    }

     @IBAction func newCodePressed(_ sender: UIButton) {
        newCodeDelegate?.newCodeAction()
     }


}
