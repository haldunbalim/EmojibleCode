//
//  AssignmentDataSource.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import Foundation

class AssignmentDataSource {
    
    //Dummy test method
    public func getAssignmentInfo() -> [Assignment] {
        return [Assignment(variable: "😀",value: "10"),
                Assignment(variable: "🥺",value: "3"),
                Assignment(variable: "🔥",value: "Hot"),
                Assignment(variable: "🙊",value: "10"),
                Assignment(variable: "🍊",value: "Orange"),
                Assignment(variable: "✨",value: "1"),
                ]
    }

}
