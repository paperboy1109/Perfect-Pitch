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
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
        userGuide.hidden = false
    }

    @IBAction func recordAudio(sender: UIButton) {
        
        //Deactivate the record button now that it's been clicked
        recordButton.enabled = false
        
        //Deactivate the user guide (label) now that recording is in progress
        userGuide.hidden = true
        
        //Make the recording notification and stop button visible
        stopButton.hidden = false
        label.hidden = false
        
        //Record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if(flag) {

            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        } else {
            
            print("The recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
            userGuide.enabled = true
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecord(sender: AnyObject) {
        
        
        // Hide the recording label when stop is pressed
        label.hidden = true
        
        // Make the user guide visible again
        userGuide.hidden = false
        
        // Make the recording process stop.
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        // Don't forget to stop recording or the app will crash 
        audioRecorder.stop()

    }
}

