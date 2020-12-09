//
//  Flip.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 9.12.2020.
//

import Foundation
import UIKit

class Flip {
    
    private init(){}
    private static var instance: Flip!
    
    public static func getInstance() -> Flip{
        if instance==nil{
            instance = Flip()
        }
        return instance
    }
    
    public func isFlipped() -> Bool{
        if UIDevice.current.orientation == .landscapeLeft ||
            UIDevice.current.orientation == .portrait ||
            UIDevice.current.orientation == .portraitUpsideDown {
            return true
        }else{
            return false
        }
    }
}
