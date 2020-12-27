//
//  TextToSpeech.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 9.12.2020.
//

import Foundation
import AVFoundation

class TextToSpeech{
    private init(){}
    private static var instance: TextToSpeech!
    public static func getInstance() -> TextToSpeech{
        if instance==nil{
            instance = TextToSpeech()
        }
        return instance
    }
    
    public func convertTextToSpeech(text: String, language: String? = nil){
        let utterance = AVSpeechUtterance(string: text)
        if language == "Turkish" {
            utterance.voice = AVSpeechSynthesisVoice(language: "tr-TR")
        }else{
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }
        utterance.rate = 0.5
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}
