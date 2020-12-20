//
//  TeacherClassDataSource.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 16.12.2020.
//

import Foundation
import Firebase

class TeacherClassDataSource{
    let database = Firestore.firestore()
    var snapshotListener:ListenerRegistration?
    let notificationCenter = NotificationCenter.default
    var classroom: [ClassModel] = []
    var classroomDataSourceIndices: [String] = []
    
    func startObservingClass(){
        guard let currentUser = AuthenticationManager.getInstance().currentUser else { return }
        let classesCollectionRef = database.collection("Classes").whereField("teacherId", isEqualTo: currentUser.uid)
        snapshotListener = classesCollectionRef.addSnapshotListener{ [unowned self] querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            classroom = documents.map{ClassModel(dictionary: $0.data())}
            classroomDataSourceIndices = documents.map{$0.documentID}
            notificationCenter.post(name: .teacherClassChanged, object: nil, userInfo:["teacherClassChanged":classroom])
        }
    }
    
    func stopObservingClass(){
        guard let snapshotListener = snapshotListener else { return }
        snapshotListener.remove()
    }
    
    
    func removeClass(classroom: ClassModel){
        var index: Int?
        for (i, document) in self.classroom.enumerated(){
            if document == classroom{
                index = i
                break
            }
        }
        UserDataSource.getInstance().resetUserClassId(classId: classroom.id)
        database.collection("Classes").document(self.classroomDataSourceIndices[index!]).delete()
    }
    
    func writeClass(className:String, classPassword:String){
        guard let currentUser = AuthenticationManager.getInstance().currentUser else { return }
        let uid = currentUser.uid
        let doc = self.database.collection("Classes").document()
        let newClassModel = ClassModel(id: String(doc.documentID.prefix(5)), teacherId:uid, className: className, password: classPassword)
        doc.setData(newClassModel.dictionary)
    }
    
    func checkClassOccurrence(name: String) -> Bool{
        for document in self.classroom{
            if document.className == name{
                return true
            }
        }
        return false
    }
    
    func addStudent(classId: String, classPassword:String, completion: @escaping (String?) -> Void){
        database.collection("Classes").whereField("id", isEqualTo: classId).whereField("password", isEqualTo: classPassword).getDocuments() { (querySnapshot, err) in
            if let err = err {
                completion("Error getting documents: \(err)")
            }
            else{
                guard let docs = querySnapshot?.documents else {
                    completion("Error getting documents: \(err)")
                    return
                }
                if docs.count == 0{
                    completion("No class with this ClassId and Password")
                }else {
                    UserDataSource.getInstance().editUserData(newData: ["classId" : classId])
                    completion(nil)
                }
                
            }
        }
    }
    
    private init(){}
    private static let instance = TeacherClassDataSource()
    public static func getInstance() -> TeacherClassDataSource{
        return .instance
    }
}
