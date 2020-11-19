//
//  AssignmentViewModel.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
import UIKit
import SwipeCellKit

class AssignmentViewModel: SwipeTableViewCell{
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var listenButton: UIButton!
    
    var model: AssignmentModel!
    
    public func configureView(assignment: AssignmentModel){
        model = assignment
        label.text = assignment.description
        listenButton.isHidden = assignment.type != .Voice
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func listenButtonOnPress(_ sender: Any) {
        AudioPlayer.getInstance().playAudio(filename: model!.getValue() as! String)
    }
    
    @IBAction func editButtonOnPress(_ sender: UIButton) {
    
    }
    
    @IBAction func trashButtonOnPress(_ sender: UIButton) {
    
    }
}
