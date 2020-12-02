//
//  AssignmentDataSource.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 1.12.2020.


import Foundation
import Firebase

class AssignmentDataSource {
    
    let database = Firestore.firestore()
    var snapshotListener:ListenerRegistration?
    let notificationCenter = NotificationCenter.default
    var assignments: [AssignmentModel] = []
    var assignmentDataSourceIndices: [String] = []
    
    func startObservingAssignments(){
        let currentUser = AuthenticationManager.getInstance().currentUser
        let userDocRef = database.collection("Users").document(currentUser!.uid)
        let assignmentsCollectionRef = userDocRef.collection("Assignments")
        snapshotListener = assignmentsCollectionRef.addSnapshotListener{ [unowned self] querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            assignments = documents.map{AssignmentModel(dictionary: $0.data())}
            assignmentDataSourceIndices = documents.map{$0.documentID}
            notificationCenter.post(name: .assignmentsChanged, object: nil, userInfo:["assignmentsChanged":assignments])
        }
    }
    
    func stopObservingAssignments(){
        guard let snapshotListener = snapshotListener else { return }
        snapshotListener.remove()
    }
    
    func editAssignment(oldAssignment: AssignmentModel, newValue: Any){
        var index: Int?
        for (i, document) in self.assignments.enumerated(){
            if document == oldAssignment{
                index = i
                break
            }
        }
        let uid = AuthenticationManager.getInstance().currentUser!.uid
        database.collection("Users").document(uid).collection("Assignments").document(self.assignmentDataSourceIndices[index!]).setData(AssignmentModel(identifier: oldAssignment.identifier, value: newValue).dictionary)
        
    }
    
    func removeAssignment(assignment: AssignmentModel){
        var index: Int?
        for (i, document) in self.assignments.enumerated(){
            if document == assignment{
                index = i
                break
            }
        }
        let uid = AuthenticationManager.getInstance().currentUser!.uid
        database.collection("Users").document(uid).collection("Assignments").document(self.assignmentDataSourceIndices[index!]).delete()
    }
    
    func writeAssignment(assignment: AssignmentModel){
        let uid = AuthenticationManager.getInstance().currentUser!.uid
        self.database.collection("Users").document(uid).collection("Assignments").addDocument(data:assignment.dictionary)
    }
    
    private init(){}
    
    private static let instance = AssignmentDataSource()
    public static func getInstance() -> AssignmentDataSource{
        return .instance
    
    }
}




