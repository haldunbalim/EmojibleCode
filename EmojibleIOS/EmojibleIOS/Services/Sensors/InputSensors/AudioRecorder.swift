//
//  AudioRecorder.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 13.11.2020.
//

import Foundation
import AVFoundation
import UIKit
class AudioRecorder{
    var recordingSession: AVAudioSession!
    var recorder: AVAudioRecorder!
    var delegate: AVAudioRecorderDelegate!
    
    
    private init(){
        recordingSession = AVAudioSession.sharedInstance()
    }
    
    func requestPermission(completion: @escaping (Bool) -> ()){
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { allowed in
                DispatchQueue.main.async {
                    if allowed {
                        completion(true)
                    } else {
                        // failed to record!
                        completion(false)
                    }
                }
            }
        } catch {
            // failed to record!
            completion(false)
        }
    }
    
    func startRecording(filename:String) {
        let audioFilename = FileSystemManager.getInstance().getPath(filename: filename)

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            recorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            recorder.delegate = delegate
            recorder.record()

        } catch {
            finishRecording()
        }
    }
    
    func finishRecording() {
        recorder.stop()
        recorder = nil
    }
    
    func isRecording()->Bool{
        return recorder != nil
    }
    
    
    
    private static var instance: AudioRecorder!
    
    public static func getInstance() -> AudioRecorder{
        if instance==nil{
            instance = AudioRecorder()
        }
        return instance
    }
}
