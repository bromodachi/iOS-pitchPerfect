//
//  PlaySoundViewController.swift
//  PitchPerfect
//
//  Created by Conrado on 2014/12/18.
//  Copyright (c) 2014年 Conrado. All rights reserved.
//

import UIKit
import AVFoundation



class PlaySoundViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    

    @IBOutlet weak var chipmunk: UIButton!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var fast: UIButton!
    @IBOutlet weak var slow: UIButton!
    @IBOutlet weak var darth: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        println("slowing audio")
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: &error)
        audioPlayer.enableRate=true
        audioEngine = AVAudioEngine()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func slowAudio(sender: UIButton) {
        editAudio(0.70)
    }
    


    @IBAction func speedAudio(sender: UIButton) {
       editAudio(1.4)
    }
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
        
    }
    func editAudio(x: Float){
        audioPlayer.stop()
        audioPlayer.currentTime=0
        audioPlayer.rate=x
        audioPlayer.play()
    }
    @IBAction func chipmunk(sender: UIButton) {
      playAudioWithVariablePitch(1000)
    }
    
    @IBAction func darhVader(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    func  playAudioWithVariablePitch(pitch: Float)
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var pitchPlayer = AVAudioPlayerNode()
        var pitchChanger = AVAudioUnitTimePitch()
        pitchChanger.pitch = pitch
        //attach nodes to the engine
        audioEngine.attachNode(pitchPlayer)
        audioEngine.attachNode(pitchChanger)
        
        //connect them to each other
        audioEngine.connect(pitchPlayer, to: pitchChanger, format: nil)
        //connect to the output
        audioEngine.connect(pitchChanger, to: audioEngine.outputNode, format: nil)
        
        //attach the audio file to the pitch player
        pitchPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        //now play the audio
        pitchPlayer.play()
    }

}
