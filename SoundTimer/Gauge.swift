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
        set { setValue(newValue, animated: false) }
    }
    
    public func setValue(value: Float, animated: Bool) {
        if(value != self.value) {
            self.backingValue = min(self.maximumValue, max(self.minimumValue, value))
            let angleRange = endAngle - startAngle
            let valueRange = CGFloat(maximumValue - minimumValue)
            let angle = CGFloat(value - minimumValue) / valueRange * angleRange + endAngle
            knobRenderer.setPointerAngle(angle, animated: animated)
        }
    }
    
    public var minimumValue: Float = 0.0
    
    public var maximumValue: Float = 1.0
    
    private let knobRenderer = KnobRenderer()
    
    public var startAngle: CGFloat {
        get { return knobRenderer.startAngle }
        set { knobRenderer.startAngle = newValue }
    }
    
    public var endAngle: CGFloat {
        get { return knobRenderer.endAngle }
        set { knobRenderer.endAngle = newValue }
    }
    
    public var lineWidth: CGFloat {
        get { return knobRenderer.lineWidth }
        set { knobRenderer.lineWidth = newValue }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        createSublayers()
    }
    
    public override func tintColorDidChange() {
        knobRenderer.strokeColor = tintColor
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSublayers() {
        knobRenderer.update(bounds)
        knobRenderer.strokeColor = tintColor
        knobRenderer.startAngle = -CGFloat(M_PI * 6.0 / 8.0)
        knobRenderer.endAngle = -CGFloat(M_PI * 2.0 / 8.0)
        knobRenderer.pointerAngle = knobRenderer.endAngle
        knobRenderer.lineWidth = 2.0
        layer.addSublayer(knobRenderer.trackLayer)
        layer.addSublayer(knobRenderer.pointerLayer)
    }
    
    public override func layoutSubviews() {
        knobRenderer.update(bounds)
    }
    
}

private class KnobRenderer {
    var strokeColor: UIColor {
        get {
            return UIColor(CGColor: trackLayer.strokeColor!)
        }
        
        set(strokeColor) {
            trackLayer.strokeColor = strokeColor.CGColor
            pointerLayer.strokeColor = strokeColor.CGColor
        }
    }
    
    var lineWidth: CGFloat = 1.0 {
        didSet { update() }
    }
    
    let trackLayer = CAShapeLayer()
    
    var startAngle: CGFloat = 0.0 {
        didSet { update() }
    }
    
    var endAngle: CGFloat = 0.0 {
        didSet { update() }
    }
    
    let pointerLayer = CAShapeLayer()
    
    var backingPointerAngle: CGFloat = 0.0
    
    var pointerAngle: CGFloat {
        get { return backingPointerAngle }
        set { setPointerAngle(newValue, animated: false) }
    }
    
    func setPointerAngle(pointerAngle: CGFloat, animated: Bool) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        pointerLayer.transform = CATransform3DMakeRotation(pointerAngle, 0.0, 0.0, 0.1)
        if animated {
            let midAngle = (max(pointerAngle, self.pointerAngle) - min(pointerAngle, self.pointerAngle) ) / 2.0 + min(pointerAngle, self.pointerAngle)
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            animation.duration = 1.0
            animation.values = [self.pointerAngle, midAngle, pointerAngle]
            animation.keyTimes = [0.0, 0.5, 1.0]
            animation.repeatCount = 10
            animation.autoreverses = true
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            pointerLayer.addAnimation(animation, forKey: nil)
        }
        CATransaction.commit()
        self.backingPointerAngle = pointerAngle
    }
    
    init() {
        trackLayer.fillColor = UIColor.clearColor().CGColor
        pointerLayer.fillColor = UIColor.clearColor().CGColor
//        trackLayer.backgroundColor =   UIColor.init(red: 0.5, green: 0.5, blue: 0.9, alpha: 0.5).CGColor
//        pointerLayer.backgroundColor = UIColor.init(red: 0.5, green: 0.9, blue: 0.5, alpha: 0.5).CGColor
    }
    
    func updateTrackLayerPath() {
        let arcCenter = CGPoint(x: trackLayer.bounds.width / 2.0, y: trackLayer.bounds.height)
        let radius = trackLayer.bounds.height
        trackLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).CGPath
    }
    
    func updatePointerLayerPath() {
        let path = UIBezierPath()
        
        let from = CGPoint(x: pointerLayer.bounds.width / 2.0 , y: pointerLayer.bounds.height  )
        let to = CGPoint(x: pointerLayer.bounds.width / 2.0, y: 0)
        
        path.addArcWithCenter(from, radius: 10.0, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.moveToPoint(from)
        path.addLineToPoint(to)
        path.addArcWithCenter(to, radius: 5.0, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        
        pointerLayer.path = path.CGPath
    }
    
    func update() {
        trackLayer.lineWidth = lineWidth
        pointerLayer.lineWidth = lineWidth
        
        updateTrackLayerPath()
        updatePointerLayerPath()
    }
    
    func update( bounds: CGRect) {
        
        let border:CGFloat = 0.1
        let offset = CGPoint(x: bounds.width * border, y: bounds.height * border)
        let newBounds = CGRect(x: 0, y: 0, width: bounds.width - 2.0 * offset.x, height: bounds.height - 2.0 * offset.y)
        
        trackLayer.bounds = newBounds
        trackLayer.position = CGPoint(x: newBounds.width / 2.0 + offset.x, y: newBounds.height / 2.0 + offset.y)
        
        pointerLayer.bounds = newBounds
        pointerLayer.position = CGPoint(x:newBounds.width / 2.0 + offset.x, y: newBounds.height + offset.y)
        pointerLayer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        
        update()
    }
}

