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
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var assignButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    fileprivate let temporaryAudioFilePath = "temp.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLanguage()
        AudioRecorder.getInstance().delegate = self
        recordingLabel.isHidden = true
    }
    func configureLanguage(){
        assignButton.setTitle("Assign".localized(), for: .normal)
        recordingLabel.text = "Recording".localized()
        cancelButton.setTitle("Cancel".localized(), for: .normal)
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
        
        assignButton.isEnabled = true
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
            if !FileSystemManager.getInstance().fileExists(filename: temporaryAudioFilePath){
                showMessagePrompt("Please record your voice using microphone button", vcToBePresented: self)
                return
            }
            let newFileName = "\(identifier).m4a"
            _ = FileSystemManager.getInstance().renameFile(previousFilename: temporaryAudioFilePath, newFilename: newFileName)
            
            GlobalMemory.getInstance().addAssignment(assignment: AssignmentModel(identifier: identifier, value: newFileName))
        }
        
        if let assignment = editAssignmentDelegate?.assignmentToBeEdited {
            if !FileSystemManager.getInstance().fileExists(filename: temporaryAudioFilePath){
                showMessagePrompt("Please record your voice using microphone button", vcToBePresented: self)
                return
            }
            let oldFileName = "\(assignment.identifier).m4a"
            _ = FileSystemManager.getInstance().deleteFile(filename: oldFileName)
         
            let newFileName = "\(assignment.identifier).m4a"
            _ = FileSystemManager.getInstance().renameFile(previousFilename: temporaryAudioFilePath, newFilename: newFileName)
            GlobalMemory.getInstance().editAssignment(assignment: assignment, newValue: newFileName)
        }
    
        dismiss()
        
     }
    
    private func dismiss(){
        assignButton.isEnabled = false
        newVoiceAssignmentDelegate?.newAssignmentIdentifier = nil
        editAssignmentDelegate?.assignmentToBeEdited = nil
        self.dismiss(animated: true, completion: nil)
    }
}
