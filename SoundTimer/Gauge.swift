//
//  Gauge.swift
//  SoundTimer
//
//  Created by Peter Vorwieger on 16.05.16.
//  Copyright © 2016 Peter Vorwieger. All rights reserved.
//

import UIKit

public class Gauge: UIView {
    
    public var value:Float = 0.5 {
        didSet {
            value = min(self.maximumValue, max(self.minimumValue, value))
            if value != oldValue {
                setPointerAngle(calculateAngle(value))
            }
        }
    }
    
    public var threshold:Float = 0.5 {
        didSet {
            threshold = min(self.maximumValue, max(self.minimumValue, threshold))
            if threshold != oldValue {
                updateThresholdPath()
            }
        }
    }
    
    public var minimumValue: Float = 0.0
    
    public var maximumValue: Float = 1.0
    
    let startAngle:CGFloat = CGFloat(-3.0 * M_PI_4)
    
    let endAngle:CGFloat = CGFloat(-M_PI_4)
    
    let trackLayer = CAShapeLayer()
    
    let pointerLayer = CAShapeLayer()
    
    let thresholdLayer = CAShapeLayer()
    
    var oldBounds:CGRect?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createSublayers()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSublayers()
    }
    
    public override func layoutSubviews() {
        if oldBounds != bounds {
            oldBounds = bounds
            update(bounds)
        }
    }
    
    private func createSublayers() {
        trackLayer.fillColor = UIColor.clearColor().CGColor
        trackLayer.strokeColor = UIColor.lightGrayColor().CGColor
        layer.addSublayer(trackLayer)

        thresholdLayer.fillColor = UIColor.clearColor().CGColor
        thresholdLayer.strokeColor = UIColor.yellowColor().CGColor
        layer.addSublayer(thresholdLayer)

        pointerLayer.fillColor = UIColor.clearColor().CGColor
        pointerLayer.strokeColor = UIColor.orangeColor().CGColor
        layer.addSublayer(pointerLayer)
    }
    
    func update(bounds: CGRect) {
        let offset = CGPoint(x: bounds.width * 0.1, y: bounds.height * 0.1)
        let newBounds = CGRect(x: 0, y: 0, width: bounds.width - 2 * offset.x, height: bounds.height - offset.y)
        
        trackLayer.bounds = newBounds
        trackLayer.position = CGPoint(x: newBounds.width / 2 + offset.x, y: newBounds.height / 2 + offset.y)
        trackLayer.lineWidth = trackLayer.bounds.height * 0.2
        updateTrackLayerPath()
        
        thresholdLayer.bounds = newBounds
        thresholdLayer.position = CGPoint(x: newBounds.width / 2 + offset.x, y: newBounds.height / 2 + offset.y)
        thresholdLayer.lineWidth = thresholdLayer.bounds.height * 0.2
        updateThresholdPath()
        
        pointerLayer.bounds = newBounds
        pointerLayer.position = CGPoint(x: newBounds.width / 2 + offset.x, y: newBounds.height + offset.y)
        pointerLayer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        pointerLayer.lineWidth = pointerLayer.bounds.height / 100.0
        updatePointerLayerPath()
    }

    private func updateTrackLayerPath() {
        let path = UIBezierPath()
        let arcCenter = CGPoint(x: trackLayer.bounds.width / 2, y: trackLayer.bounds.height)
        let radius = trackLayer.bounds.height * 0.9
        path.addArcWithCenter(arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        trackLayer.path = path.CGPath
    }

    private func updateThresholdPath() {
        let angle = startAngle + calculateAngle(threshold) - endAngle
        let path = UIBezierPath()
        let arcCenter = CGPoint(x: thresholdLayer.bounds.width / 2, y: thresholdLayer.bounds.height)
        let radius = thresholdLayer.bounds.height * 0.9
        path.addArcWithCenter(arcCenter, radius: radius, startAngle: angle, endAngle: endAngle, clockwise: true)
        thresholdLayer.path = path.CGPath
    }

    private func updatePointerLayerPath() {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: pointerLayer.bounds.width / 2, y: pointerLayer.bounds.height))
        path.addLineToPoint(CGPoint(x: pointerLayer.bounds.width / 2, y: 0))
        pointerLayer.path = path.CGPath
    }

    private func setPointerAngle(pointerAngle: CGFloat) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        pointerLayer.transform = CATransform3DMakeRotation(pointerAngle, 0.0, 0.0, 0.1)
        CATransaction.commit()
    }
    
    private func calculateAngle(value:Float) -> CGFloat {
        let angleRange = endAngle - startAngle
        let valueRange = CGFloat(maximumValue - minimumValue)
        return CGFloat(value - minimumValue) / valueRange * angleRange + endAngle
    }

}

