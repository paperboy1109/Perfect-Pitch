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
    
    //let changePitchEffect = AVAudioUnitTimePitch()
    
    
    
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

        stopPlayer()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let addDistortionEffect = AVAudioUnitDistortion()
        addDistortionEffect.loadFactoryPreset(AVAudioUnitDistortionPreset.SpeechCosmicInterference)
        
        
        audioEngine.attachNode(addDistortionEffect)
        audioEngine.connect(audioPlayerNode, to: addDistortionEffect, format: nil)
        audioEngine.connect(addDistortionEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    
    
    
    @IBAction func playEchoAudio(sender: AnyObject) {

        stopPlayer()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let addEchoEffect = AVAudioUnitReverb()
        addEchoEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        addEchoEffect.wetDryMix = 64
        
        audioEngine.attachNode(addEchoEffect)
        audioEngine.connect(audioPlayerNode, to: addEchoEffect, format: nil)
        audioEngine.connect(addEchoEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    
    
    func playAudioWithVariableSpeed(speed: Float) {

        stopPlayer()
        
        audioPlayer.rate = speed
        
        startPlayer()
        
    }
    
    
    func playAudioWithVariablePitch(pitch: Float) {
        
        stopPlayer()

        let changePitchEffect = AVAudioUnitTimePitch()
        
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        
        playbackRecording(audioPlayerNode)
//        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
//        try! audioEngine.start()
//        
//        audioPlayerNode.play()
        
        
        
        //playAddedEffect()
        
    }
    
    
    // TODO: Add arguments and code so that this function can create all 6 effects
//    func playAddedEffect() {
//        
//        let audioPlayerNode = AVAudioPlayerNode()
//        audioEngine.attachNode(audioPlayerNode)
//        
//        
//        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
//        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
//        
//        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
//        try! audioEngine.start()
//        
//        audioPlayerNode.play()
//        
//    }
    
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
