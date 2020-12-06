//
//  EmojiChecker.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 13.11.2020.
//

import Foundation
class EmojiChecker{
    var availableEmojisList:[String] = []
    var availableEmojisSet:Set<String>
    
    
    private init(){
        availableEmojisList = EmojiChecker.readEmojisJson()
        availableEmojisSet =  Set(availableEmojisList.map { $0 })
    }
    private static let instance = EmojiChecker()
    public static func getInstance() -> EmojiChecker{
        return .instance
    }
    
    // TODO: Not Implemented Yet
    func isValidIdentifier(_ identifier:String) -> Bool{
        
        return availableEmojisSet.contains(identifier)
    }
    
    func getAvailableEmojis() -> [String] {
        return availableEmojisList
    }
    
    private static func readEmojisJson() -> [String]{
        if let path = Bundle.main.path(forResource: "Emojis", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                 return jsonResult as! [String]
              } catch {
                   // handle error
                return []
              }
        }
        return []
    }
    
}
