//
//  SoundManager.swift
//  MatchGame
//
//  Created by Cường Nguyễn on 2018-10-03.
//  Copyright © 2018 Cuong Nguyen. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    static func playSound(_ effect:SoundEffect) {
        
        var soundfileName = ""
        
        // Determine which sound affect we want to play
        // And set the appropriate file name
        switch effect {
            
        case .flip:
            soundfileName = "cardflip"
            
        case .shuffle:
            soundfileName = "shuffle"
            
        case .match:
            soundfileName = "dingcorrect"
            
        case .nomatch:
            soundfileName = "dingwrong"
        }
        
        // Get the path to the sound file inside the bundble
        let bundlePath = Bundle.main.path(forResource: soundfileName, ofType: "wav")
        
        guard bundlePath != nil else {
            print("couldn't find sound file \(soundfileName) in the bundble")
            return
        }
        
        // Create URL object from this string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do {
            // Create AudioPlayer onject
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            // Play the sound
            audioPlayer?.play()
        }
        catch {
            
            // Couldn't create audioPlayer object
            print("Couldn't create the audio player object for sound file \(soundfileName)")
        }
    }
}
