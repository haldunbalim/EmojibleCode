//
//  Shake.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 9.12.2020.
//

import Foundation
import CoreMotion

class Shake{
    let motionManager = CMMotionManager()
    
    private init(){}
    private static var instance: Shake!
    public static func getInstance() -> Shake{
        if instance==nil{
            instance = Shake()
        }
        return instance
    }
    
    public func shakeAction(threshold: Double){
        self.motionManager.startAccelerometerUpdates()
        let queue = OperationQueue()
        if motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = 0.01
            motionManager.startDeviceMotionUpdates(to: queue) {(data, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                let rate = abs(data.userAcceleration.x) + abs(data.userAcceleration.y) + abs(data.userAcceleration.z)
                
                DispatchQueue.main.async {
                    if rate >= threshold{
                        //UpdateUI
                        self.motionManager.stopAccelerometerUpdates()
                        self.motionManager.stopDeviceMotionUpdates()
                    }else{
                        //UpdateUI
                    }
                }
            }
        }
    }
}

