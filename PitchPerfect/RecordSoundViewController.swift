//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Conrado on 2014/11/21.
//  Copyright (c) 2014年 Conrado. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingInProgess: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
   
    
    @IBOutlet weak var recordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        //hide the stop button
        stopButton.hidden=true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden=false
        recordButton.enabled=false
        //TODO: Show text "recording in progress"
        recordingInProgess.hidden = false
        //TODO: Record the user's voice
        println("in recordAudio")
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        // delete all old content
        let fm = NSFileManager()
        let oldFiles = fm.enumeratorAtPath(dirPath)
        while let file = oldFiles?.nextObject() as? String {
            fm.removeItemAtPath("\(dirPath)/\(file)", error: nil)
        }
        
        //create new content
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        //timestamp
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate=self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    

    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        //save recorded audio
        if(flag){
        recordedAudio = RecordedAudio()
        recordedAudio.filePathUrl = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent //name of recorded file
        
        // move to next scene
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            //handle this in a better way
            recordButton.enabled = true
            stopButton.enabled = true
        }
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            //define its approopriate type. Used Segways destination view
            //controller property destination property to get a handle on the 2nd control
            //as to to correct type
            let playSoundsVC:PlaySoundViewController = segue.destinationViewController as
                PlaySoundViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio=data
        }
    }
    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgess.hidden = true
        recordButton.enabled=true
         audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false ,error :nil)
        
        
    }
}

