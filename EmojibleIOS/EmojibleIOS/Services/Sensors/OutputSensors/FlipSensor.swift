//
//  Flip.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 9.12.2020.
//

import Foundation
import UIKit

class FlipSensor {
    
    private init(){}
    private static var instance: FlipSensor!
    
    public static func getInstance() -> FlipSensor{
        if instance==nil{
            instance = FlipSensor()
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
