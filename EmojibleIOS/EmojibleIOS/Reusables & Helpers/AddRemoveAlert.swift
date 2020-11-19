//
//  AddRemoveAlert.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 19.11.2020.
//

import UIKit

class AddRemoveAlert: CustomAlertViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func cancelButtonOnPress(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func deleteButtonOnPress(_ sender: Any) {
        //GlobalMemory.getInstance().removeContent(assignment: <#T##AssignmentModel#>)
        dismiss()
     }
    
    private func dismiss(){
         self.dismiss(animated: true, completion: nil)
    }
}

