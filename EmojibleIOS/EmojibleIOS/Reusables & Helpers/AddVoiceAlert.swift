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
    
    @IBOutlet weak var identifierTextField: UITextField!
    @IBOutlet weak var recordingLabel: UILabel!
    fileprivate let temporaryAudioFilePath = "temp.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        identifierTextField.becomeFirstResponder()
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
        
        guard let identifier = identifierTextField.text, identifier != "" else {
            showMessagePrompt("Identifier cannot be empty", vcToBePresented: self.delegate!)
            _ = FileSystemManager.getInstance().deleteFile(filename: temporaryAudioFilePath)
            return
        }
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
        GlobalMemory.getInstance().addAssignment(assignment: AssignmentModel(identifier: identifier, value: newFileName))
        
        dismiss()
        
     }
    
    private func dismiss(){
        identifierTextField.text = ""
        identifierTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
   

}
