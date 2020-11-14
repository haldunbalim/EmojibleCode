//
//  AudioPlayer.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
import AVFoundation


class AudioPlayer{
    var sound: AVAudioPlayer!
    
    public func playAudio(filename:String){
        let url = FileSystemManager.getInstance().getPath(filename: filename)
        do {
            sound = try AVAudioPlayer(contentsOf: url)
            sound.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    private init(){}
    private static var instance: AudioPlayer!
    
    public static func getInstance() -> AudioPlayer{
        if instance==nil{
            instance = AudioPlayer()
        }
        return instance
    }
}
