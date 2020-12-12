//
//  TeacherTutorialDataSource.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 12.12.2020.
//

import Foundation
import Firebase

class TeacherTutorialDataSource {
    
    let database = Firestore.firestore()
    var snapshotListener:ListenerRegistration?
    let notificationCenter = NotificationCenter.default
    var tutorials: [CodeModel] = []
    var tutorialsDataSourceIndices: [String] = []
    
    func startObservingTutorials(){
        guard let currentUser = AuthenticationManager.getInstance().currentUser else { return }
        let userDocRef = database.collection("Users").document(currentUser.uid)
        let tutorialsCollectionRef = userDocRef.collection("Tutorials")
        snapshotListener = tutorialsCollectionRef.addSnapshotListener{ [unowned self] querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            tutorials = documents.map{CodeModel(dictionary: $0.data())}
            tutorialsDataSourceIndices = documents.map{$0.documentID}
            notificationCenter.post(name: .teacherTutorialsChanged, object: nil, userInfo:["teacherTutorialsChanged":tutorials])
        }
    }
    
    func stopObservingTutorials(){
        guard let snapshotListener = snapshotListener else { return }
        snapshotListener.remove()
    }
    
    func editTutorial(oldTutorial: CodeModel, newTutorial:CodeModel){
        guard let currentUser = AuthenticationManager.getInstance().currentUser else { return }

        var index: Int?
        for (i, document) in self.tutorials.enumerated(){
            if document == oldTutorial{
                index = i
                break
            }
        }
        let uid = currentUser.uid
        database.collection("Users").document(uid).collection("Programs").document(self.tutorialsDataSourceIndices[index!]).setData(newTutorial.dictionary)
    }
    
    func removeTutorial(tutorial: CodeModel){
        guard let currentUser = AuthenticationManager.getInstance().currentUser else { return }
        var index: Int?
        for (i, document) in self.tutorials.enumerated(){
            if document == tutorial{
                index = i
                break
            }
        }
        let uid = currentUser.uid
        database.collection("Users").document(uid).collection("Tutorials").document(self.tutorialsDataSourceIndices[index!]).delete()
    }
    
    func writeTutorial(tutorial: CodeModel){
        guard let currentUser = AuthenticationManager.getInstance().currentUser else { return }
        let uid = currentUser.uid
        self.database.collection("Users").document(uid).collection("Tutorials").addDocument(data:tutorial.dictionary)
    }
    
    private init(){}
    
    private static let instance = TeacherTutorialDataSource()
    public static func getInstance() -> TeacherTutorialDataSource{
        return .instance
    }
}
