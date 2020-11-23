//
//  TutorialDataSource.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import Foundation

class TutorialDataSource {
     
    // Dummy test method
    public func getTutorials() -> [CodeModel] {
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
    private static let instance = TutorialDataSource()
    public static func getInstance() -> TutorialDataSource{
        return .instance
    }
}




