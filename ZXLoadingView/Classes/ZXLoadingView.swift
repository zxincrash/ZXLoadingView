//
//  ZXLoadingView.swift
//  ZXLoadingView (https://github.com/zxin2928/ZXLoadingView)
//
//  Created by zhaoxin on 2017/11/17.
//  Copyright © 2017年 zhaoxin. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
let kZXRingStrokeAnimationKey:String = "zxloadingview.stroke"
let kZXRingRotationAnimationKey:String = "zxloadingview.rotation"

public class ZXLoadingView: UIView {
    // default is YES. calls -setHidden when animating gets set to NO
    public var hidesWhenStopped:Bool!{
        didSet{
            self.isHidden = !self.isAnimating && hidesWhenStopped
            
        }
        
    }
    public var color:UIColor!
    
    /** Sets the line width of the  circle. */
    public var lineWidth:CGFloat!{
        didSet{
            self.progressLayer.lineWidth = lineWidth
            self.updatePath()
            
        }
    }
    
    /** Sets the line cap of the circle. */
    public var lineCap:String!{
        didSet{
            self.progressLayer.lineCap = lineCap
            self.updatePath()
            
        }
    }
    
    /** Specifies the timing function to use for the control's animation. Defaults to kCAMediaTimingFunctionEaseInEaseOut */
    var timingFunction:CAMediaTimingFunction!
    
    /** Property indicating the duration of the animation, default is 1.5s. Should be set prior to -[startAnimating] */
    public var duration:TimeInterval!
    
    /** Property to manually set the percent complete of the spinner, in case you don't want to start at 0. Valid values are 0.0 to 1.0 */
    public var percentComplete:CGFloat!{
        didSet{
            if self.isAnimating {
                return
            }
            
            self.progressLayer.strokeStart = 0.0
            self.progressLayer.strokeEnd = self.percentComplete
            
        }
        
    }
    
    lazy var isAnimating:Bool! = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize(){
        self.hidesWhenStopped = false
        self.duration = 1.5
        self.percentComplete = 0.0
        self.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        self.layer.addSublayer(self.progressLayer)
        
        // See comment in resetAnimations on why this notification is used.
        NotificationCenter.default.addObserver(self, selector:#selector(resetAnimations),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        self.invalidateIntrinsicContentSize()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.progressLayer.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        
        self.invalidateIntrinsicContentSize()
        
        self.updatePath()
    }
    
    private func intrinsicContentSize() -> CGSize {
        return CGSize.init(width: self.bounds.width, height: self.bounds.height)
    }
    
    override public func tintColorDidChange() {
        super.tintColorDidChange()
        self.progressLayer.strokeColor = self.tintColor.cgColor;
        
    }
    
    @objc private func resetAnimations(){
        // If the app goes to the background, returning it to the foreground causes the animation to stop (even though it's not explicitly stopped by our code). Resetting the animation seems to kick it back into gear.
        if (self.isAnimating) {
            self.stopAnimating()
            self.startAnimating()
        }
    }
    
    public func setAnimating(animate:Bool){
        (animate ? self.startAnimating() : self.stopAnimating())
        
    }
    
    
    public func startAnimating(){
        if self.isAnimating{
            return
        }
        let animation:CABasicAnimation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.duration = self.duration/0.375
        animation.fromValue = 0
        animation.toValue = Double.pi*2
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        self.progressLayer.add(animation, forKey: kZXRingStrokeAnimationKey)
        
        let headAnimation:CABasicAnimation = CABasicAnimation()
        headAnimation.keyPath = "strokeStart"
        headAnimation.duration = self.duration/1.5
        headAnimation.fromValue = 0.0
        headAnimation.toValue = 0.25
        headAnimation.timingFunction = self.timingFunction
        
        let tailAnimation:CABasicAnimation = CABasicAnimation()
        tailAnimation.keyPath = "strokeEnd"
        tailAnimation.duration = self.duration/1.5
        tailAnimation.fromValue = 0.0
        tailAnimation.toValue = 1.0
        tailAnimation.timingFunction = self.timingFunction
        
        let endHeadAnimation:CABasicAnimation = CABasicAnimation()
        endHeadAnimation.keyPath = "strokeStart"
        endHeadAnimation.beginTime = self.duration/1.5
        endHeadAnimation.duration = self.duration/3.0
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1.0
        endHeadAnimation.timingFunction = self.timingFunction
        
        let endTailAnimation:CABasicAnimation = CABasicAnimation()
        endTailAnimation.keyPath = "strokeEnd"
        endTailAnimation.beginTime = self.duration/1.5
        endTailAnimation.duration = self.duration/3.0
        endTailAnimation.fromValue = 1.0
        endTailAnimation.toValue = 1.0
        endTailAnimation.timingFunction = self.timingFunction
        
        let animations:CAAnimationGroup = CAAnimationGroup()
        animations.duration = self.duration
        animations.animations = [headAnimation,tailAnimation,endHeadAnimation,endTailAnimation]
        animations.repeatCount = .infinity
        animations.isRemovedOnCompletion = false
        self.progressLayer.add(animations, forKey: kZXRingRotationAnimationKey)
        
        
        self.isAnimating = true;
        
        if self.hidesWhenStopped {
            self.isHidden = false;
        }
    }
    
    public func stopAnimating(){
        if !self.isAnimating{
            return
        }
        self.progressLayer.removeAnimation(forKey: kZXRingStrokeAnimationKey)
        self.progressLayer.removeAnimation(forKey: kZXRingRotationAnimationKey)
        self.isAnimating = false;
        
        if self.hidesWhenStopped {
            self.isHidden = true
        }
    }
    
    private func updatePath() {
        let center:CGPoint = CGPoint.init(x: self.bounds.midX, y: self.bounds.midY)
        let radius:CGFloat = min(self.bounds.width*0.5, self.bounds.height*0.5 - self.progressLayer.lineWidth*0.5)
        let startAngle:CGFloat = CGFloat(0)
        let endAngle = CGFloat(Double.pi*2)
        
        let path:UIBezierPath = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        self.progressLayer.path = path.cgPath
        
        self.progressLayer.strokeStart = 0.0
        self.progressLayer.strokeEnd = self.percentComplete
    }
    
    lazy var progressLayer: CAShapeLayer = {
        let layer:CAShapeLayer = CAShapeLayer()
        layer.strokeColor = self.tintColor.cgColor
        layer.fillColor = nil
        layer.lineWidth = 1.5
        
        return layer
    }()
    
}

