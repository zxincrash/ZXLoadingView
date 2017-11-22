//
//  ZXLoadingViewController.swift
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

class ZXLoadingViewController: UIViewController {
    
    var animate:Bool! = false
    
    let margin:CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.loadingView)
        self.loadingView.startAnimating()

        self.view.addSubview(self.animateLab)
        self.view.addSubview(self.animateSwitch)
        
        self.view.addSubview(self.lineWidthLab)
        self.view.addSubview(self.lineWidthSlide)
        
        self.view.addSubview(self.changeColorBtn)
        self.view.addSubview(self.changeLineWidthBtn)
        self.view.addSubview(self.changeSquareCapBtn)
        self.view.addSubview(self.changeRoundCapBtn)
        self.view.addSubview(self.changeButtCapBtn)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var loadingView: ZXLoadingView = {
        let rect:CGRect = CGRect.init(x: self.view.center.x, y: self.view.center.y, width: 100, height: 100)
        let view:ZXLoadingView = ZXLoadingView.init(frame:rect)
        view.center = CGPoint.init(x: self.view.center.x, y: self.view.center.y-80)
        view.color = UIColor.blue
        view.lineWidth = 2.0
        return view
    }()
    
    //动画控制
    lazy var animateLab: UILabel = {
        var lab:UILabel = UILabel.init(frame: CGRect.init(x: 10, y: self.loadingView.frame.maxY + 50, width: 120, height: 20))
        lab.font = UIFont.systemFont(ofSize: 13)
        lab.text = "Animating"
        return lab
    }()
    
    lazy var animateSwitch: UISwitch = {
        var aniSwitch:UISwitch = UISwitch.init(frame: CGRect.init(x: self.animateLab.frame.maxX + margin, y: self.animateLab.frame.minY, width: 50, height: 20))
        aniSwitch.isOn = true
        aniSwitch.addTarget(self, action: #selector(switchDidChange(sender:)), for: .valueChanged)
        return aniSwitch
    }()
    
    @objc func switchDidChange(sender:UISwitch){
        animateSwitch.isOn = sender.isOn
        
        self.animate = sender.isOn;
        self.loadingView.setAnimating(animate: self.animate)
        self.lineWidthLab.text = (self.animate
            ? "Duration"
            : "Percent Complete");
        self.loadingView.percentComplete =  CGFloat(self.lineWidthSlide.value/self.lineWidthSlide.maximumValue)
    }
    
    //动画时间控制
    lazy var lineWidthLab: UILabel = {
        var lab:UILabel = UILabel.init(frame: CGRect.init(x: self.animateLab.frame.minX, y: self.animateSwitch.frame.maxY + margin, width: 120, height: 20))
        lab.font = UIFont.systemFont(ofSize: 13)
        lab.text = "Duration"
        return lab
    }()
    
    lazy var lineWidthSlide: UISlider = {
        var slide:UISlider = UISlider.init(frame: CGRect.init(x: self.animateLab.frame.maxX, y: self.animateSwitch.frame.maxY+margin, width: 150, height: 20))
        slide.addTarget(self, action: #selector(slideValueChanged(sender:)), for: .valueChanged)
        slide.addTarget(self, action: #selector(slideValueUpdated(sender:)), for: .touchUpOutside)
        slide.addTarget(self, action: #selector(slideValueUpdated(sender:)), for: .touchUpInside)
        return slide
    }()
    
    lazy var changeColorBtn: UIButton = {
        var button:UIButton = UIButton.init(type: UIButtonType.system)
        button.frame = CGRect.init(x: self.animateLab.frame.minX, y: self.lineWidthLab.frame.maxY + 2*margin, width: 150, height: 20)
        button.setTitle("change color", for: UIControlState.normal)
        button.addTarget(self, action: #selector(changeColorAction(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var changeLineWidthBtn: UIButton = {
        var button:UIButton = UIButton.init(type: UIButtonType.system)
        button.frame = CGRect.init(x: self.animateLab.frame.minX, y: self.changeColorBtn.frame.maxY + margin, width: 150, height: 20)
        button.setTitle("change line width", for: UIControlState.normal)
        button.addTarget(self, action: #selector(changeLineWidthAction(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var changeSquareCapBtn: UIButton = {
        var button:UIButton = UIButton.init(type: UIButtonType.system)
        button.frame = CGRect.init(x: self.animateLab.frame.minX, y: self.changeLineWidthBtn.frame.maxY + margin, width: 150, height: 20)
        button.setTitle("change square cap", for: UIControlState.normal)
        button.addTarget(self, action: #selector(changeSquareCapAction(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var changeRoundCapBtn: UIButton = {
        var button:UIButton = UIButton.init(type: UIButtonType.system)
        button.frame = CGRect.init(x: self.animateLab.frame.minX, y: self.changeSquareCapBtn.frame.maxY + margin, width: 150, height: 20)
        button.setTitle("change round cap", for: UIControlState.normal)
        button.addTarget(self, action: #selector(changeRoundCapAction(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var changeButtCapBtn: UIButton = {
        var button:UIButton = UIButton.init(type: UIButtonType.system)
        button.frame = CGRect.init(x: self.animateLab.frame.minX, y: self.changeRoundCapBtn.frame.maxY + margin, width: 150, height: 20)
        button.setTitle("change butt cap", for: UIControlState.normal)
        button.addTarget(self, action: #selector(changeButtCapAction(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    @objc func slideValueChanged(sender:UISlider){
        if !self.animate {
            self.loadingView.percentComplete = CGFloat(self.lineWidthSlide.value/self.lineWidthSlide.maximumValue)
        }
        
    }
    
    @objc func slideValueUpdated(sender:UISlider){
        if self.animate {
            self.loadingView.stopAnimating()
            self.loadingView.duration = TimeInterval(self.lineWidthSlide.value)
            self.loadingView.startAnimating()
        }
    }
    

    
    @objc func changeColorAction(sender:UIButton){
        self.loadingView.tintColor = ZXLoadingViewController.randomColor()
    }
    
    @objc func changeLineWidthAction(sender:UIButton){
        self.loadingView.lineWidth = CGFloat(drand48())*10;
        if (self.loadingView.lineWidth == 0){
            self.loadingView.lineWidth = 0.1

        }

    }
    
    @objc func changeSquareCapAction(sender:UIButton){
        self.loadingView.lineCap = kCALineCapSquare

    }
    
    @objc func changeRoundCapAction(sender:UIButton){
        self.loadingView.lineCap = kCALineCapRound
    }
    
    @objc func changeButtCapAction(sender:UIButton){
        self.loadingView.lineCap = kCALineCapButt
    }
    // MARK: - Helper methods
     class func randomColor() -> UIColor {
        let hue:CGFloat = CGFloat(drand48())
        let saturation:CGFloat = CGFloat(drand48()) + 0.5
        let brightness:CGFloat = CGFloat(drand48()) + 0.5
        
        return UIColor.init(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
