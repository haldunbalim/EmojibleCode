//
//  ProgramNewCodeViewModel.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 23.11.2020.
//

import UIKit

class ProgramNewCodeViewModel: UICollectionViewCell {
    
    var delegate: AddNewProgramProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureView () {

    }

     @IBAction func newCodePressed(_ sender: UIButton) {
        delegate?.addNewProgram()
     }


}
