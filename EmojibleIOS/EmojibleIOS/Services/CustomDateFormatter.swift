//
//  CustomDateFormatter.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
class CustomDateFormatter{
    let dateFormatter = DateFormatter()
    
    func getStringFromDate(from:Date) -> String{
        return dateFormatter.string(from: from)
    }
    
    func getDateFromString(from:String) -> Date{
        return dateFormatter.date(from: from)!
    }
    
    private init(){
        dateFormatter.dateFormat = "dd MMM yyyy"
    }
    private static let instance = CustomDateFormatter()
    public static func getInstance() -> CustomDateFormatter{
        return .instance
    }
}
