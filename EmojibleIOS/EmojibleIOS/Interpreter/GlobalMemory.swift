//
//  GlobalMemory.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
class GlobalMemory: Memory{
    override private init(assignments:[AssignmentModel]? = nil) {
        super.init(assignments: GlobalMemory.readAssignmentsFromJson())
    }
    
    private static var instance: GlobalMemory!
    public static func getInstance() -> GlobalMemory{
        if(instance == nil){
            instance = GlobalMemory()
        }
        return .instance
    }
    
    override func editAssignment(assignment: AssignmentModel, newValue: Any) {
        super.editAssignment(assignment: assignment, newValue: newValue)
        GlobalMemory.writeAssignmentsToJson(assignments: self.assignments)
        NotificationCenter.default.post(name: .assignmentsChanged, object: nil)
    }
    
    override func removeContent(assignment: AssignmentModel) {
        super.removeContent(assignment: assignment)
        GlobalMemory.writeAssignmentsToJson(assignments: self.assignments)
        EmojiChecker.getInstance().updateEmojis(emoji: assignment.identifier, tag: "Remove")
        NotificationCenter.default.post(name: .assignmentsChanged, object: nil)
    }
    
    override func addAssignment(assignment: AssignmentModel) {
        super.addAssignment(assignment: assignment)
        GlobalMemory.writeAssignmentsToJson(assignments: self.assignments)
        EmojiChecker.getInstance().updateEmojis(emoji: assignment.identifier, tag: "Add")
        NotificationCenter.default.post(name: .assignmentsChanged, object: nil)
    }
    
    private static func readAssignmentsFromJson() -> [AssignmentModel]{
        do{
            let fileManager = FileManager.default
            let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let jsonUrl = url.appendingPathComponent("Assignments.json")
            
            let data = try Data(contentsOf: jsonUrl, options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            
            if let jsonResult = jsonResult as? Dictionary<String, Any>{
                var assignmentList: [AssignmentModel] = []
                for (key, value) in jsonResult{
                    assignmentList.append(AssignmentModel(identifier: key, value: value))
                }
                return assignmentList
            }
            
        }catch let err{
            print(err.localizedDescription)
        }
        return []
    }
    
    private static func writeAssignmentsToJson(assignments: [AssignmentModel]){
        var dict: [String: Any] = [:]
        for each in assignments {
            dict[each.identifier] = each.getValue()
        }
        do{
            let fileManager = FileManager.default
            let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let jsonUrl = url.appendingPathComponent("Assignments.json")
            try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted).write(to: jsonUrl, options: .atomic)
        }
        catch let err{
            print(err.localizedDescription)
            
        }
    }
}
