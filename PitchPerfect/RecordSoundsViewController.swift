//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Moviefreak89 on 15/10/2018.
//  Copyright © 2018 Moviefreak89. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    // MARK: button state change function
    func enableRecordButton (_ enabled : Bool){
        if enabled {
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            recordingLabel.text = "Tap to Record"
        }else {
            recordingLabel.text = "Recording"
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        enableRecordButton(true)
    }

    // MARK: record voice
    @IBAction func recordAudio(_ sender: Any) {
        enableRecordButton(false)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    // MARK: stop recording
    @IBAction func stopRecording(_ sender: Any) {
        enableRecordButton(true)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    // MARK: send to next screen
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
       performSegue(withIdentifier: "StopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    // MARK: prepare segue send audio file
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StopRecording" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
}

