//
//  AddVoiceAlert.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 13.11.2020.
//

import Foundation
import UIKit
import AVFoundation

class AddVoiceAlert: CustomAlertViewController, AVAudioRecorderDelegate{
    var newVoiceAssignmentDelegate: AssignmentNewAssignmentAlert?
    var editAssignmentDelegate: AssignmentEditAlert?
    
    @IBOutlet weak var recordingLabel: UILabel!
    fileprivate let temporaryAudioFilePath = "temp.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioRecorder.getInstance().delegate = self
        recordingLabel.isHidden = true
    }
    
    @IBAction func microphoneButtonOnPress(_ sender: Any) {
        AudioRecorder.getInstance().requestPermission(){ [unowned self] success in
            if success{
                if AudioRecorder.getInstance().recorder == nil {
                    AudioRecorder.getInstance().startRecording(filename: temporaryAudioFilePath)
                    recordingLabel.isHidden = false
                } else {
                    AudioRecorder.getInstance().finishRecording()
                    recordingLabel.isHidden = true
                }
            }else{
                self.dismiss()
                self.delegate!.showMessagePrompt("To record voice you must give permission", vcToBePresented:self.delegate!)
            }
        }
     }
    
    @IBAction func cancelButtonOnPress(_ sender: Any) {
         dismiss()
     }
    
    @IBAction func assignButtonOnPress(_ sender: Any) {
        if AudioRecorder.getInstance().isRecording(){
            AudioRecorder.getInstance().finishRecording()
            recordingLabel.isHidden = true
        }
        
        if let identifier = newVoiceAssignmentDelegate?.newAssignmentIdentifier {
            if !EmojiChecker.getInstance().isValidIdentifier(identifier){
                showMessagePrompt("\(identifier) is not a valid identifier. Please use a single emoji", vcToBePresented: self)
                _ = FileSystemManager.getInstance().deleteFile(filename: temporaryAudioFilePath)
                return
            }
            if !FileSystemManager.getInstance().fileExists(filename: temporaryAudioFilePath){
                showMessagePrompt("Please record your voice using microphone button", vcToBePresented: self)
                return
            }
            
            let newFileName = "\(identifier).m4a"
            _ = FileSystemManager.getInstance().renameFile(previousFilename: temporaryAudioFilePath, newFilename: newFileName)
            
            AssignmentDataSource.getInstance().writeAssignment(assignment: AssignmentModel(identifier: identifier, value: newFileName))
        }
        
        if let assignment = editAssignmentDelegate?.assignmentToBeEdited {
            if !FileSystemManager.getInstance().fileExists(filename: temporaryAudioFilePath){
                showMessagePrompt("Please record your voice using microphone button", vcToBePresented: self)
                return
            }
            
            let newFileName = "\(assignment.identifier).m4a"
            _ = FileSystemManager.getInstance().renameFile(previousFilename: temporaryAudioFilePath, newFilename: newFileName)
            
            GlobalMemory.getInstance().editAssignment(assignment: assignment, newValue: newFileName)
        }
    
        dismiss()
        
     }
    
    private func dismiss(){
        newVoiceAssignmentDelegate?.newAssignmentIdentifier = nil
        editAssignmentDelegate?.assignmentToBeEdited = nil
        self.dismiss(animated: true, completion: nil)
    }
}
