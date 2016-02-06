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
        
        print("Slow-Button has been clicked")
        
//        audioPlayer.rate = 0.5
//        
//        startPlayer()
        
        playAudioWithVariableSpeed(0.5)
        
    }
    
    
    
    @IBAction func playSoundFast(sender: AnyObject) {
        
        print("Fast-Button has been clicked")
        
//        audioPlayer.rate = 1.75
//        
//        startPlayer()
        
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
        
        print("Stop-Button has been clicked")
        audioPlayer.stop()

    }
    
    func startPlayer() {
        
        audioPlayer.stop() // good practice
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
    }
    
    
    @IBOutlet var volumeLevel: UISlider!
    
    
    @IBAction func changeVol(sender: AnyObject) {
        
        audioPlayer.volume = volumeLevel.value
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3")
        
        //Updated:
        /*
        do {
            
            try audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3")!))
            
            audioPlayer.enableRate = true
            
            
        } catch {
            // It didn't work
            print("The filepath did not work")
        }
        */
        
        // Updated again:
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            
//            var filePathUrl = NSURL.fileURLWithPath(filePath)
//            
//        } else {
//            print("the filePath is empty")
//        }
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)

    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
