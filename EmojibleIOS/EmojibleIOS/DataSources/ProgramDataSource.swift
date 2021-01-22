//
//  ProgramDataSource.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 2.12.2020.
//

import Foundation
import Firebase

class ProgramDataSource {
    
    let database = Firestore.firestore()
    var snapshotListener:ListenerRegistration?
    let notificationCenter = NotificationCenter.default
    var programs: [CodeModel] = []
    var programDataSourceIndices: [String] = []
    var lastPrevEditIndex = 0
    
    func startObservingProgram(){
        guard let currentUser = AuthenticationManager.getInstance().currentUser else { return }
        let userDocRef = database.collection("Users").document(currentUser.uid)
        let programsCollectionRef = userDocRef.collection("Programs")
        snapshotListener = programsCollectionRef.addSnapshotListener{ [unowned self] querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            programs = documents.map{CodeModel(dictionary: $0.data())}
            programDataSourceIndices = documents.map{$0.documentID}
            notificationCenter.post(name: .programsChanged, object: nil, userInfo:["programsChanged":programs])
        }
    }
    
    func stopObservingProgram(){
        guard let snapshotListener = snapshotListener else { return }
        snapshotListener.remove()
    }
    
    func editProgram(oldProgram: CodeModel, newProgram:CodeModel){
        guard let currentUser = AuthenticationManager.getInstance().currentUser else { return }

        for (i, document) in self.programs.enumerated(){
            if document == oldProgram{
                lastPrevEditIndex = i
                break
            }
        }

        let uid = currentUser.uid
        database.collection("Users").document(uid).collection("Programs").document(self.programDataSourceIndices[lastPrevEditIndex]).setData(newProgram.dictionary)
    }
    
    func removeProgram(program: CodeModel){
        guard let currentUser = AuthenticationManager.getInstance().currentUser else { return }
        var index: Int?
        for (i, document) in self.programs.enumerated(){
            if document == program{
                index = i
                break
            }
        }
        let uid = currentUser.uid
        database.collection("Users").document(uid).collection("Programs").document(self.programDataSourceIndices[index!]).delete()
    }
    
    func writeProgram(program: CodeModel){
        guard let currentUser = AuthenticationManager.getInstance().currentUser else { return }
        let uid = currentUser.uid
        self.database.collection("Users").document(uid).collection("Programs").addDocument(data:program.dictionary)
    }
    
    private init(){}
    
    private static let instance = ProgramDataSource()
    public static func getInstance() -> ProgramDataSource{
        return .instance
    
    }
}




