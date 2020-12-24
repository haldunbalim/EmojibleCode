//
//  TutorialDataSource.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import Foundation
import Firebase

class TutorialDataSource {
<<<<<<< HEAD
    
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
=======
     
    // Dummy test method
    public func getTutorialInfo() -> [Tutorial] {
        return [Tutorial(color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), level: "Beginner", tutorialNumber: "Tutorial 1"),
                Tutorial(color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), level: "Beginner", tutorialNumber: "Tutorial 2"),
                Tutorial(color: #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), level: "Intermediate", tutorialNumber: "Tutorial 3"),
                Tutorial(color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), level: "Advance", tutorialNumber: "Tutorial 4")
        ]
    }
>>>>>>> main
}




