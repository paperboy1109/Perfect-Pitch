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
    
    
    @IBAction func playDistortedAudio(sender: AnyObject) {
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        playAddedEffect( {
            
            let addEchoEffect = AVAudioUnitReverb()
            addEchoEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
            addEchoEffect.wetDryMix = 64
            
            let addDistortionEffect = AVAudioUnitDistortion()
            addDistortionEffect.loadFactoryPreset(AVAudioUnitDistortionPreset.SpeechCosmicInterference)
            
            self.audioEngine.attachNode(addDistortionEffect)
            self.audioEngine.connect(audioPlayerNode, to: addDistortionEffect, format: nil)
            self.audioEngine.connect(addDistortionEffect, to: self.audioEngine.outputNode, format: nil)
            
            }, node: audioPlayerNode)

        
    }
    
    
    @IBAction func playEchoAudio(sender: AnyObject) {

        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        playAddedEffect( {
            
            let addEchoEffect = AVAudioUnitReverb()
            addEchoEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
            addEchoEffect.wetDryMix = 64

            self.audioEngine.attachNode(addEchoEffect)
            self.audioEngine.connect(audioPlayerNode, to: addEchoEffect, format: nil)
            self.audioEngine.connect(addEchoEffect, to: self.audioEngine.outputNode, format: nil)
            
            }, node: audioPlayerNode)
        
    }
    
    
    func playAudioWithVariableSpeed(speed: Float) {

        stopPlayer()
        
        audioPlayer.rate = speed
        
        startPlayer()
        
    }
    
    
    func playAudioWithVariablePitch(pitch: Float) {

        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        playAddedEffect( {
            
            let changePitchEffect = AVAudioUnitTimePitch()
            changePitchEffect.pitch = pitch
            
            self.audioEngine.attachNode(changePitchEffect)
            self.audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
            self.audioEngine.connect(changePitchEffect, to: self.audioEngine.outputNode, format: nil)

            }, node: audioPlayerNode)
        
    }
    
    
    func playAddedEffect(effect: () -> Void, node: AVAudioPlayerNode) {
        
        stopPlayer()
        
        effect()
        
        playbackRecording(node)
        
    }
    
    
    @IBAction func stopSoundPlayback(sender: AnyObject) {

        stopPlayer()

    }
    
    func stopPlayer() {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
    }
    
    func startPlayer() {
        
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
    }
    
    func playbackRecording(playerNode: AVAudioPlayerNode) {
        
        playerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        playerNode.play()
        
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
