//
//  ViewController.swift
//  SoundTimer
//
//  Created by Peter Vorwieger on 15.05.16.
//  Copyright © 2016 Peter Vorwieger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var gauge: Gauge!
    @IBOutlet var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gauge.minimumValue = slider.minimumValue
        gauge.maximumValue = slider.maximumValue
        gauge.value = slider.value
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sliderValueChanged(slider: UISlider) {
        gauge.value = slider.value
    }

}

