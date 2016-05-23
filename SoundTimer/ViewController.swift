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
        audioMeter = AudioMeter()
        audioMeter.delegate = self
        audioMeter.initSession()
        audioMeter.start()
    }
    
    func audioMeterLevelChanged(decibels: Float) {
        let linear = pow (10, decibels / 20)
        gauge.value = linear
    }
    
    func audioMeterStateChanged(state: AudioMeterState) {
        print("state \(state)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sliderValueChanged(slider: UISlider) {
        gauge.maximumValue = 1.0 - slider.value
    }

    @IBAction func thresholdValueChanged(sender: AnyObject) {
        gauge.threshold = threshold.value
    }

}

