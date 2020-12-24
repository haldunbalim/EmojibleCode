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
    var reservedEmojisSet:Set<String>
    var emojiIndexDict : [String: Int] = [:]
    
    private init(){
        availableEmojisList = EmojiChecker.readAvailableEmojisFromJson()
        emojiIndexDict = EmojiChecker.readEmojiIndexPairsFromJson()
        
        availableEmojisSet =  Set(availableEmojisList.map { $0 })
        reservedEmojisSet = Set(Constants.reservedEmojis.map { $0 })
        availableEmojisSet.subtract(reservedEmojisSet)
        
        startEmojis()
    }
    
    private static let instance = EmojiChecker()
    public static func getInstance() -> EmojiChecker{
        return .instance
    }
    
    func isValidIdentifier(_ identifier:String) -> Bool{
        return availableEmojisSet.contains(identifier)
    }
    
    func getAvailableEmojis() -> [String] {
        return availableEmojisList
    }
    
    func startEmojis() {
        var indexes : [Int] = []
        for i in 0..<availableEmojisList.count{
            for j in 0..<GlobalMemory.getInstance().getAssignments().count{
                if availableEmojisList[i] == GlobalMemory.getInstance().getAssignments()[j].identifier {
                    indexes.append(i)
                    break
                }
            }
        }
        for i in indexes.reversed(){
            availableEmojisList.remove(at: i)
        }
    }
    
    func updateEmojis(emoji: String, tag:String) {
        if tag == "Remove" {
            availableEmojisList.insert(emoji, at: findPosition(emoji: emoji))
        }else if tag == "Add" {
            for i in 0..<availableEmojisList.count{
                if emoji == availableEmojisList[i]{
                    availableEmojisList.remove(at: i)
                    break
                }
            }
        }
    }
    
    func findPosition(emoji: String) -> Int {
        var position = emojiIndexDict[emoji]
        for assignment in GlobalMemory.getInstance().getAssignments() {
            if emojiIndexDict[assignment.identifier]! < emojiIndexDict[emoji]!{
                position! -= 1
            }
        }
        return position ?? 0
    }
    
    private static func readAvailableEmojisFromJson() -> [String]{
        if let path = Bundle.main.path(forResource: "Emojis", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                return jsonResult as! [String]
            }catch let err{
                print(err.localizedDescription)
            }
        }
        return []
    }
    
    private static func readEmojiIndexPairsFromJson() -> [String: Int] {
        if let path = Bundle.main.path(forResource: "EmojisIndexes", ofType: "json") {
            do{
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                return jsonResult as! [String:Int]
            }catch let err{
                print(err.localizedDescription)
            }
        }
        return [:]
    }
}
