//
//  Shake.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 9.12.2020.
//

import Foundation
import UIKit

extension RunScreenVC{
    override func becomeFirstResponder() -> Bool {
        return true
    }
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if activate && motion == .motionShake{
            self.shaked = true
        }
    }
    
    func isShaked() -> Bool{
        return self.shaked
    }
    func resetShaked(){
        self.shaked = false
    }
}
