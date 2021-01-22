//
//  TouchSensor.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 22.01.2021.
//

import Foundation
import UIKit

class TouchSensor {
    
    private init(){}
    private static var instance: TouchSensor!
    
    public static func getInstance() -> TouchSensor{
        if instance==nil{
            instance = TouchSensor()
        }
        return instance
    }
    
    public func isTouched() -> Bool{
        return RunCodeCoordinator.getInstance().runScreen.isBeingTouched
    }
}

