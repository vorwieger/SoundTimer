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
    var gauge: Gauge!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gauge = Gauge(frame: gaugePlaceholder.bounds)
        gaugePlaceholder.addSubview(gauge)
        gauge.tintColor = UIColor.orangeColor()
        gauge.backgroundColor = UIColor.darkGrayColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        gauge.setValue(1.0, animated: true)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

