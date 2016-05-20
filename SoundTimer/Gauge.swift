//
//  Gauge.swift
//  SoundTimer
//
//  Created by Peter Vorwieger on 16.05.16.
//  Copyright © 2016 Peter Vorwieger. All rights reserved.
//

import UIKit

public class Gauge: UIView {
    
    private var backingValue: Float = 0.0
    
    public var value: Float {
        get { return backingValue }
        set {
            if (newValue != backingValue) {
                self.backingValue = min(self.maximumValue, max(self.minimumValue, newValue))
                let angleRange = endAngle - startAngle
                let valueRange = CGFloat(maximumValue - minimumValue)
                let angle = CGFloat(self.backingValue - minimumValue) / valueRange * angleRange + endAngle
                setPointerAngle(angle)
            }
        }
    }
    
    public var minimumValue: Float = 0.0
    
    public var maximumValue: Float = 1.0
    
    let startAngle:CGFloat = CGFloat(-3.0 * M_PI_4)
    
    let endAngle:CGFloat = CGFloat(-M_PI_4)
    
    let trackLayer = CAShapeLayer()
    
    let pointerLayer = CAShapeLayer()
    
    let showLayers = true

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
            print("layoutSubviews")
            oldBounds = bounds
            update(bounds)
        }
    }
    
    private func createSublayers() {
        trackLayer.fillColor = UIColor.clearColor().CGColor
        trackLayer.strokeColor = UIColor.lightGrayColor().CGColor
        if showLayers {trackLayer.backgroundColor =   UIColor.init(red: 0.5, green: 0.5, blue: 0.9, alpha: 0.5).CGColor}
        layer.addSublayer(trackLayer)

        pointerLayer.fillColor = UIColor.clearColor().CGColor
        pointerLayer.strokeColor = UIColor.orangeColor().CGColor
        if showLayers {pointerLayer.backgroundColor = UIColor.init(red: 0.5, green: 0.9, blue: 0.5, alpha: 0.5).CGColor}
        layer.addSublayer(pointerLayer)
    }
    
    func update(bounds: CGRect) {
        let offset = CGPoint(x: bounds.width * 0.1, y: bounds.height * 0.1)
        let newBounds = CGRect(x: 0, y: 0, width: bounds.width - 2 * offset.x, height: bounds.height - offset.y)
        
        trackLayer.bounds = newBounds
        trackLayer.position = CGPoint(x: newBounds.width / 2 + offset.x, y: newBounds.height / 2 + offset.y)
        
        pointerLayer.bounds = newBounds
        pointerLayer.position = CGPoint(x:newBounds.width / 2 + offset.x, y: newBounds.height + offset.y)
        pointerLayer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        
        trackLayer.lineWidth = trackLayer.bounds.height * 0.2
        pointerLayer.lineWidth = 2.0

        updateTrackLayerPath()
        updatePointerLayerPath()
    }

    private func updateTrackLayerPath() {
        let path = UIBezierPath()
        let arcCenter = CGPoint(x: trackLayer.bounds.width / 2.0, y: trackLayer.bounds.height)
        let radius = trackLayer.bounds.height * 0.9
        path.addArcWithCenter(arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        trackLayer.path = path.CGPath
    }
    
    private func updatePointerLayerPath() {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: pointerLayer.bounds.width / 2.0, y: pointerLayer.bounds.height))
        path.addLineToPoint(CGPoint(x: pointerLayer.bounds.width / 2.0, y: 0))
        pointerLayer.path = path.CGPath
    }

    private func setPointerAngle(pointerAngle: CGFloat) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        pointerLayer.transform = CATransform3DMakeRotation(pointerAngle, 0.0, 0.0, 0.1)
        CATransaction.commit()
    }

}

