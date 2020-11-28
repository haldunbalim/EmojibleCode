//
//  GlobalMemory.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
class GlobalMemory{
    private var assignments: [AssignmentModel] = []
    
    private init(){
        assignments = [AssignmentModel(identifier: "😀",value: "10"),
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
    }
    
    public func getAssignments() -> Array<AssignmentModel>{
        return assignments
    }
    
    public func editAssignment(assignment: AssignmentModel, newValue: Any){
        for i in 0..<assignments.count{
            if assignments[i] == assignment{
                assignments[i].setValue(value: newValue)
                break
            }
        }
        NotificationCenter.default.post(name: .assignmentsChanged, object: nil)
    }
    
    public func addAssignment(assignment:AssignmentModel){
        for i in 0..<assignments.count{
            if assignments[i] == assignment{
                assignments[i] = assignment
                NotificationCenter.default.post(name: .assignmentsChanged, object: nil)
                return
            }
        }
        assignments.append(assignment)
        NotificationCenter.default.post(name: .assignmentsChanged, object: nil)
    }

    
    public func removeContent(assignment:AssignmentModel) {
        for i in 0..<assignments.count{
            if assignments[i] == assignment{
                assignments.remove(at: i)
                break
            }
        }
        NotificationCenter.default.post(name: .assignmentsChanged, object: nil)
    }
    
    
    private static var instance: GlobalMemory!
    public static func getInstance() -> GlobalMemory{
        if(instance == nil){
            instance = GlobalMemory()
        }
        return .instance
    }
}
