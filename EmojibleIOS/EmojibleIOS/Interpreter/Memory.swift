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
    }
    
    public func addAssignment(assignment:AssignmentModel){
        if assignments.contains(assignment){
            editAssignment(assignment: assignment, newValue: assignment.getValue())
        }else{
            assignments.append(assignment)
        }
    }

    
    public func removeContent(assignment:AssignmentModel) {
        for i in 0..<assignments.count{
            if assignments[i] == assignment{
                assignments.remove(at: i)
                break
            }
        }
    }
    
}
