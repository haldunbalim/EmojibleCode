//
//  PreviousCodeDataSource.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 14.11.2020.
//

import Foundation
class PreviousCodeDataSource{
    
    
    public func getPreviousCodes() -> [CodeModel] {
        return [CodeModel(name: "STT Tutorial", code: "[🦜 💬] 👉 🐤 , 📱 🐤 "),
                CodeModel(name:"For loops",code:"[🔁 5] [ 📣 🍎 ]"),
                CodeModel(name:"If statement",code:"🤔 [ 🔉 < 40 ] [ 📣 🍎 ] [ 🤔 [ 🔉 > 80 ] [📣 🍌] ]"),
                CodeModel(name:"Guess Game",code:"""
                        [👻 1, 100] 👉 🐤 // Generate a random number, you can assign it to any available emoji
                          
                          [🔢 1, 100] 👉 🐄 // Get numeric user input between 1 and 100, assign the value to cow

                          🪐 [ 🐤 = 🐄 ] [ // start a loop condition until baby chick is equal to cow

                              🤔 [ 🐤 < 🐄 ] [📱  🟦 ] [ 📱  🟥] // display red if baby chick is less than cow, blue vice versa

                              [🔢 1, 100] 👉 🐄 // get another user input

                          ]

                          [ 📱  🟩 ] // when the condition is met, display green

                        """)
        ]
    }
    
    
    
    private init(){
    }
    private static let instance = PreviousCodeDataSource()
    public static func getInstance() -> PreviousCodeDataSource{
        return .instance
    }
}
