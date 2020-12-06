//
//  GlobalMemory.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
class GlobalMemory: Memory{
    
    override private init(assignments:[AssignmentModel]? = nil) {
        let assignments = [AssignmentModel(identifier: "😀",value: "10"),
                       AssignmentModel(identifier: "🥺",value: "3"),
                       AssignmentModel(identifier: "🔥",value: "Hot"),
                       AssignmentModel(identifier: "🙊",value: "10"),
                       AssignmentModel(identifier: "🍊",value: "Orange"),
                       AssignmentModel(identifier: "🤮",value: "BOO"),
                       AssignmentModel(identifier: "🤕",value: "10"),
                       AssignmentModel(identifier: "🤑",value: "Money"),
                       AssignmentModel(identifier: "🤠",value: "LOL"),
                       AssignmentModel(identifier: "🤢",value: "14"),
                       AssignmentModel(identifier: "🥴",value: "112"),
                       AssignmentModel(identifier: "🤧",value: "COVID"),
                       AssignmentModel(identifier: "😷",value: "19"),
                    ]
        super.init(assignments: assignments)
    }
    
    private static var instance: GlobalMemory!
    public static func getInstance() -> GlobalMemory{
        if(instance == nil){
            instance = GlobalMemory()
        }
        return .instance
    }
}
