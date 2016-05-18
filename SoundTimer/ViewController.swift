//
//  ViewController.swift
//  SoundTimer
//
//  Created by Peter Vorwieger on 15.05.16.
//  Copyright © 2016 Peter Vorwieger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var gaugePlaceholder: UIView!
    @IBOutlet var slider: UISlider!
    
    var gauge: Gauge!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gauge = Gauge(frame: gaugePlaceholder.bounds)
        gaugePlaceholder.addSubview(gauge)
        gauge.tintColor = UIColor.orangeColor()
        gauge.backgroundColor = UIColor.darkGrayColor()
        gauge.value = slider.value
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sliderValueChanged(slider: UISlider) {
        gauge.setValue(slider.value, animated: false)
    }

}

