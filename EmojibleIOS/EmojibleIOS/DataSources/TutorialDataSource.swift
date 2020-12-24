//
//  TutorialDataSource.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import Foundation
import Firebase

class TutorialDataSource {
    
    let database = Firestore.firestore()
    var snapshotListener:ListenerRegistration?
    let notificationCenter = NotificationCenter.default
    var tutorialDataSourceIndices:[String] = []
    
    func startObservingDefaultTutorials(){
        let tutorialsCollectionRef = database.collection("DefaultTutorials")
        snapshotListener = tutorialsCollectionRef.addSnapshotListener{ [unowned self] querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            let defaultTutorials = documents.map{CodeModel(dictionary: $0.data())}
            tutorialDataSourceIndices = documents.map{$0.documentID}
            notificationCenter.post(name: .defaultTutorialsChanged, object: nil, userInfo:["defaultTutorials":defaultTutorials])
        }
    }
    
    func stopObservingDefaultTutorials(){
        guard let snapshotListener = snapshotListener else { return }
        snapshotListener.remove()
    }
    
    func editTutorial(index:Int, newModel: CodeModel){
        database.collection("DefaultTutorials").document(tutorialDataSourceIndices[index]).setData(newModel.dictionary)
    }
    
    private init(){
    }
    private static let instance = TutorialDataSource()
    public static func getInstance() -> TutorialDataSource{
        return .instance
    }
}




