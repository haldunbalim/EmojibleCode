//
//  Light.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 9.12.2020.
//

import Foundation


class Light{
    private init(){}
    private static var instance: Light!
    
    public static func getInstance() -> Light{
        if instance==nil{
            instance = Light()
        }
        return instance
    }
}
