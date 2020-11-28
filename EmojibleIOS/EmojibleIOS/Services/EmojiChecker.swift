//
//  EmojiChecker.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 13.11.2020.
//

import Foundation
class EmojiChecker{
    
    private init(){
    }
    private static let instance = EmojiChecker()
    public static func getInstance() -> EmojiChecker{
        return .instance
    }
    
    // TODO: Not Implemented Yet
    func isValidIdentifier(_ identifier:String) -> Bool{
        return true
    }
    
    func getAvailableEmojis() -> [String] {
        return Constants.EMOJI_LIST
    }
    
}
