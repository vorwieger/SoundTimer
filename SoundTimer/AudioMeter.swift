//
//  AudioMeter.swift
//  SoundTimer
//
//  Created by Peter Vorwieger on 21.05.16.
//  Copyright © 2016 Peter Vorwieger. All rights reserved.
//

import UIKit
import AVFoundation

enum AudioMeterState {
    case UNKNOWN, ERROR, NO_MICRO, READY, WAITING, RUNNING
}

protocol AudioMeterDelegate {
    func audioMeterStateChanged(state:AudioMeterState)
    func audioMeterLevelChanged(level:Float)
}

class AudioMeter: NSObject, AVAudioRecorderDelegate {

    var delegate : AudioMeterDelegate?
    
    var state:AudioMeterState = AudioMeterState.UNKNOWN {
        didSet {
            delegate?.audioMeterStateChanged(state)
        }
    }
    
    var recorder:AVAudioRecorder!
    var session: AVAudioSession!
    var refreshRate:Float = 20.0

    let url = NSURL.fileURLWithPathComponents([NSTemporaryDirectory(),"record.cav"])!
    
    override init() {
        super.init()
        let minimalSettings = [
            AVSampleRateKey: 8000.0,
            AVLinearPCMBitDepthKey: 8,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.Low.rawValue
        ]
        recorder = try? AVAudioRecorder(URL:url, settings:minimalSettings)
        recorder.delegate = self
        recorder.meteringEnabled = true
        recorder.prepareToRecord()
    }
    
    var fileSize:UInt64 {
        get {
            var fileSize : UInt64 = 0
            do {
                let fileManager = NSFileManager.defaultManager()
                let attr : NSDictionary? = try fileManager.attributesOfItemAtPath(url.path!)
                if let _attr = attr {
                    fileSize = _attr.fileSize();
                }
            } catch {
                print("Error: \(error)")
            }
            return fileSize
        }
    }
    
    func initSession() {
        session = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                do {
                    try self.session.setCategory(AVAudioSessionCategoryRecord)
                    try self.session.setActive(true)
                } catch _ {
                    self.state = AudioMeterState.ERROR
                }
                self.state = AudioMeterState.READY
            } else {
                self.state = AudioMeterState.NO_MICRO
            }
        }
    }

    func start() {
        state = AudioMeterState.WAITING
        recorder.recordForDuration(60.0)
        let intervall = NSTimeInterval(1.0 / refreshRate)
        let callback = #selector(levelTimerCallback(_:))
        NSTimer.scheduledTimerWithTimeInterval(intervall, target:self, selector:callback, userInfo:nil, repeats:true)
    }
    
    func stop() {
        recorder.stop()
       
    }    

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        state = AudioMeterState.READY
        //print("fileSize \(fileSize)")
    }
    
    func levelTimerCallback(timer:NSTimer) {
        if recorder.recording {
            recorder.updateMeters()
            var decibel = recorder.averagePowerForChannel(0)
            decibel = decibel > 0 ? 0 : decibel
            delegate?.audioMeterLevelChanged(decibel)
        } else {
            timer.invalidate();
            start()
            //delegate?.audioMeterLevelChanged(-160)
        }
    }
    
}
