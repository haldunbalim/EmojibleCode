//
//  StudentsInClassDataSource.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 19.12.2020.
//

import Foundation
import Firebase

class StudentsInClassDataSource{
    let database = Firestore.firestore()
    var snapshotListener:ListenerRegistration?
    let notificationCenter = NotificationCenter.default
    var students: [StudentModel] = []
    
    func startObservingStudentsInAClass(classId: String){
        let classesCollectionRef = database.collection("Users").whereField("classId", isEqualTo: classId)
        snapshotListener = classesCollectionRef.addSnapshotListener{ [unowned self] querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            students = documents.map{StudentModel(dictionary: $0.data())}
            notificationCenter.post(name: .studentsInClassChanged, object: nil, userInfo:["studentsInClassChanged":students])
        }
    }
    
    func stopObservingStudentsInAClass(){
        guard let snapshotListener = snapshotListener else { return }
        snapshotListener.remove()
    }
    
    private init(){}
    private static let instance = StudentsInClassDataSource()
    public static func getInstance() -> StudentsInClassDataSource{
        return .instance
    }
}
