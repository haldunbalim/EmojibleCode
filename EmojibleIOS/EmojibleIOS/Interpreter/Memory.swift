//
//  Memory.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 4.12.2020.
//

import Foundation
class Memory{
    internal var assignments: [AssignmentModel] = []
    
    init(assignments:[AssignmentModel]? = nil) {
        self.assignments = (assignments == nil) ? []:assignments!
    }
    
    public func getAssignments() -> Array<AssignmentModel>{
        return assignments
    }
    
    public func contains(variableName:String) -> Bool{
        for assignment in assignments{
            if assignment.identifier == variableName{
                return true
            }
        }
        return false
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
    
}
