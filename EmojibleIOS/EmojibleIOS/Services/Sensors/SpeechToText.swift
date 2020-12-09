//
//  SpeechToText.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 9.12.2020.
//

import Foundation
import Speech

class SpeechToText{
    private init(){}
    private static var instance: SpeechToText!
    public static func getInstance() -> SpeechToText{
        if instance==nil{
            instance = SpeechToText()
        }
        return instance
    }
    
    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    return
                } else {
                    print("Transcription permission was declined.")
                }
            }
        }
    }
    
    public func convertSpeechToText(url: URL) -> String{
        var s = ""
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: url)
        recognizer?.recognitionTask(with: request) {(result, error) in
             guard let result = result else {
                 print("There was an error: \(error!)")
                 return
             }
             if result.isFinal {
                print(result.bestTranscription.formattedString)
                s = result.bestTranscription.formattedString
             }
        }
        return s
    }
}
