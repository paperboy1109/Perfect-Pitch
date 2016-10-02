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
    
    
    
    @IBAction func playSoundSlow(_ sender: AnyObject) {
        
        playAudioWithVariableSpeed(0.5)
        
    }
    
    
    @IBAction func playSoundFast(_ sender: AnyObject) {
        
        playAudioWithVariableSpeed(1.75)
        
    }
    
    @IBAction func PlayChipmunkAudio(_ sender: AnyObject) {
        
        playAudioWithVariablePitch(1000)
        
    }
    
    
    @IBAction func playDarthvaderAudio(_ sender: AnyObject) {
        
        playAudioWithVariablePitch(-1000)
        
    }
    
    
    @IBAction func playDistortedAudio(_ sender: AnyObject) {
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        playAddedEffect( {
            
            let addEchoEffect = AVAudioUnitReverb()
            addEchoEffect.loadFactoryPreset(AVAudioUnitReverbPreset.cathedral)
            addEchoEffect.wetDryMix = 64
            
            let addDistortionEffect = AVAudioUnitDistortion()
            addDistortionEffect.loadFactoryPreset(AVAudioUnitDistortionPreset.speechCosmicInterference)
            
            self.audioEngine.attach(addDistortionEffect)
            self.audioEngine.connect(audioPlayerNode, to: addDistortionEffect, format: nil)
            self.audioEngine.connect(addDistortionEffect, to: self.audioEngine.outputNode, format: nil)
            
            }, node: audioPlayerNode)

        
    }
    
    
    @IBAction func playEchoAudio(_ sender: AnyObject) {

        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        playAddedEffect( {
            
            let addEchoEffect = AVAudioUnitReverb()
            addEchoEffect.loadFactoryPreset(AVAudioUnitReverbPreset.cathedral)
            addEchoEffect.wetDryMix = 64

            self.audioEngine.attach(addEchoEffect)
            self.audioEngine.connect(audioPlayerNode, to: addEchoEffect, format: nil)
            self.audioEngine.connect(addEchoEffect, to: self.audioEngine.outputNode, format: nil)
            
            }, node: audioPlayerNode)
        
    }
    
    
    func playAudioWithVariableSpeed(_ speed: Float) {

        stopPlayer()
        
        audioPlayer.rate = speed
        
        startPlayer()
        
    }
    
    
    func playAudioWithVariablePitch(_ pitch: Float) {

        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        playAddedEffect( {
            
            let changePitchEffect = AVAudioUnitTimePitch()
            changePitchEffect.pitch = pitch
            
            self.audioEngine.attach(changePitchEffect)
            self.audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
            self.audioEngine.connect(changePitchEffect, to: self.audioEngine.outputNode, format: nil)

            }, node: audioPlayerNode)
        
    }
    
    
    func playAddedEffect(_ effect: () -> Void, node: AVAudioPlayerNode) {
        
        stopPlayer()
        
        effect()
        
        playbackRecording(node)
        
    }
    
    
    @IBAction func stopSoundPlayback(_ sender: AnyObject) {

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
    
    func playbackRecording(_ playerNode: AVAudioPlayerNode) {
        
        playerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        try! audioEngine.start()
        playerNode.play()
        
    }
    

    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = try! AVAudioPlayer(contentsOf: receivedAudio.filePathUrl as URL)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl as URL)

    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    



}
