//
//  ViewController.swift
//  SoundTimer
//
//  Created by Peter Vorwieger on 15.05.16.
//  Copyright © 2016 Peter Vorwieger. All rights reserved.
//

import UIKit

class ViewController: UIViewController,AudioMeterDelegate {

    @IBOutlet var gauge: Gauge!
    @IBOutlet var slider: UISlider!
    @IBOutlet var threshold: UISlider!
    var audioMeter:AudioMeter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gauge.value = slider.value
        gauge.threshold = threshold.value
        gauge.refreshRate = 20.0
        audioMeter = AudioMeter()
        audioMeter.refreshRate = gauge.refreshRate
        audioMeter.delegate = self
        audioMeter.initSession()
        audioMeter.start()
    }
    
    
    func decibelToLinear(decibels:Float) -> Float {
        var level:Float
        let minDecibels:Float = -60.0
        if (decibels < minDecibels) {
            level = 0.0
        } else if (decibels >= 0.0) {
            level = 1.0
        } else {
            let root:Float = 2.0
            let minAmp = powf(10.0, 0.05 * minDecibels)
            let inverseAmpRange = 1.0 / (1.0 - minAmp)
            let amp = powf(10.0, 0.05 * decibels)
            let adjAmp = (amp - minAmp) * inverseAmpRange
            level = powf(adjAmp, 1.0 / root);
        }
        return level
    }
    
    func audioMeterLevelChanged(decibels: Float) {
        gauge.value = decibelToLinear(decibels) * slider.value
    }
    
    func audioMeterStateChanged(state: AudioMeterState) {
//        print("state \(state)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func sliderValueChanged(slider: UISlider) {
        //gauge.maximumValue = 1.0 - slider.value
    }

    @IBAction func thresholdValueChanged(sender: AnyObject) {
        gauge.threshold = threshold.value
    }

}

