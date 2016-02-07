//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Daniel J Janiak on 1/16/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    
    var audioFile:AVAudioFile!
    
    
    
    @IBAction func playSoundSlow(sender: AnyObject) {
        
        playAudioWithVariableSpeed(0.5)
        
    }
    
    
    
    @IBAction func playSoundFast(sender: AnyObject) {
        
        playAudioWithVariableSpeed(1.75)
        
    }
    
    @IBAction func PlayChipmunkAudio(sender: AnyObject) {
        
        playAudioWithVariablePitch(1000)
        
    }
    
    
    @IBAction func playDarthvaderAudio(sender: AnyObject) {
        
        playAudioWithVariablePitch(-1000)
        
    }
    
    
    
    func playAudioWithVariableSpeed(speed: Float) {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.rate = speed
        
        startPlayer()
        
    }
    
    
    func playAudioWithVariablePitch(pitch: Float) {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()

        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
        
    }
    
    @IBAction func stopSoundPlayback(sender: AnyObject) {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()

    }
    
    func startPlayer() {
        
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
    }
    

    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)

    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    



}
