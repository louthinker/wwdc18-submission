
/* Class: MyAudio */
/* Play sound files to improve the gameplay. */

import Foundation
import AVFoundation

public class MyAudio {
    
    // Sounds
    var soundDropDisc: AVAudioPlayer?
    var soundEnd: AVAudioPlayer?
    var soundExit: AVAudioPlayer?
    var soundSelectColumn: AVAudioPlayer?
    var soundStart: AVAudioPlayer?
    
    // Play the disc drop sound
    func playSoundDropDisc() {
        let path = Bundle.main.path(forResource: "Sounds/DropDiscSound.wav", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        do {
            soundDropDisc = try AVAudioPlayer(contentsOf: url)
            soundDropDisc?.play()
        } catch { /* Error */ }
    }
    
    // Play the end of game sound
    func playSoundEnd() {
        let path = Bundle.main.path(forResource: "Sounds/EndSound.wav", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        do {
            soundSelectColumn = try AVAudioPlayer(contentsOf: url)
            soundSelectColumn?.play()
        } catch { /* Error */ }
    }
    
    // Play the exit game sound
    func playSoundExit() {
        let path = Bundle.main.path(forResource: "Sounds/ExitSound.wav", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        do {
            soundSelectColumn = try AVAudioPlayer(contentsOf: url)
            soundSelectColumn?.play()
        } catch { /* Error */ }
    }
    
    // Play the column selection sound
    func playSoundSelectColumn() {
        let path = Bundle.main.path(forResource: "Sounds/SelectColumnSound.wav", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        do {
            soundSelectColumn = try AVAudioPlayer(contentsOf: url)
            soundSelectColumn?.play()
        } catch { /* Error */ }
    }
    
    // Play the start sound
    func playSoundStart() {
        let path = Bundle.main.path(forResource: "Sounds/StartSound.wav", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        do {
            soundSelectColumn = try AVAudioPlayer(contentsOf: url)
            soundSelectColumn?.play()
        } catch { /* Error */ }
    }
    
}
