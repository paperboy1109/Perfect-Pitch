//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Daniel J Janiak on 1/14/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var label: UILabel!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var userGuide: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stopButton.isHidden = true
        recordButton.isEnabled = true
        userGuide.isHidden = false
    }
    
    @IBAction func recordAudio(_ sender: UIButton) {
        
        recordButton.isEnabled = false
        userGuide.isHidden = true
        stopButton.isHidden = false
        label.isHidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        
        let pathArray = [dirPath, recordingName]
        //let filePath = URL.fileURL(withPathComponents: pathArray)
        // * Syntax change necessary for Swift 3.0 update
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch {
            print("Failed to set AVAudioSession category")
        }
        
        
        do {
            
            try audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            
        } catch {
            
            print("Failed to record audio")
        }
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if(flag) {
            
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            
            self.performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
            
        } else {
            
            print("The recording was not successful")
            recordButton.isEnabled = true
            stopButton.isHidden = true
            userGuide.isEnabled = true
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destination as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecord(_ sender: AnyObject) {
        
        label.isHidden = true
        userGuide.isHidden = false
        let audioSession = AVAudioSession.sharedInstance()
        
        audioRecorder.stop()
        
        do {
            try audioSession.setActive(false)
        } catch {
            print("Failed to change audio session to inactive")
        }
        
    }
}

