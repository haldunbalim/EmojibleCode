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
                       AssignmentModel(identifier: "✨",value: "1"),
                    ]
    }
    
    public func getAssignments() -> Array<AssignmentModel>{
        return assignments
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
