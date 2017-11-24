# ZXLoadingView

[![CI Status](http://img.shields.io/travis/zxin2928/ZXLoadingView.svg?style=flat)](https://travis-ci.org/zxin2928/ZXLoadingView)
[![Version](https://img.shields.io/cocoapods/v/ZXLoadingView.svg?style=flat)](http://cocoapods.org/pods/ZXLoadingView)
[![License](https://img.shields.io/cocoapods/l/ZXLoadingView.svg?style=flat)](http://cocoapods.org/pods/ZXLoadingView)
[![Platform](https://img.shields.io/cocoapods/p/ZXLoadingView.svg?style=flat)](http://cocoapods.org/pods/ZXLoadingView)

![image](https://github.com/zxin2928/ZXLoadingView/blob/master/ZXLoadingView/demo.gif) 
## Example

To run the example project directory.

``` swift
// Initialize the progress view
let loadingView:ZXLoadingView = ZXLoadingView.init(frame:CGRect.init(x: self.view.center.x, y: self.view.center.y, width: 100, height: 100))

// Set the line width of the loadingView
loadingView.lineWidth = 2.0
// Set the tint color of the loadingView
loadingView.tintColor = .red

// Add it as a subview
self.view.addSubview(loadingView)

...

// Start & stop animations
loadingView.startAnimating()
loadingView.stopAnimating()

```
Also Support Xib & StoryBoard


The `lineWidth` and `tintColor` properties can even be set after animating has been started, which you can observe in the included example project.

## Requirements

swift4.0

## Installation

ZXLoadingView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZXLoadingView'
```

## Author

zxin2928, 125773896@qq.com

## License

ZXLoadingView is available under the MIT license. See the LICENSE file for more info.




