//
//  AssignmentDataSource.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import Foundation

class AssignmentDataSource {
    
    //Dummy test method
    public func getAssignmentInfo() -> [AssignmentModel] {
        return [AssignmentModel(variable: "😀",value: "10"),
                AssignmentModel(variable: "🥺",value: "3"),
                AssignmentModel(variable: "🔥",value: "Hot"),
                AssignmentModel(variable: "🙊",value: "10"),
                AssignmentModel(variable: "🍊",value: "Orange"),
                AssignmentModel(variable: "✨",value: "1"),
                ]
    }

}
