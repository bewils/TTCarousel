//
//  TTCarouselIndicator.swift
//  TTCarousel
//
//  Created by 李锐 on 2017/4/5.
//  Copyright © 2017年 李锐. All rights reserved.
//

import UIKit

class TTCarouselIndicator: UIView {
  
  var indicatorCount: Int = 0 {
    didSet {
      self.updateSize()
      self.setNeedsDisplay()
      if indicatorCount < oldValue {
        changeCountAnimation()
      } else {
        changeOpacityAnimation()
      }
    }
  }
  var isLeft = true
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    UIColor(red: 73 / 255, green: 144 / 255, blue: 226 / 255, alpha: 1).setFill()
    UIRectFill(rect)
    
    for i in 0..<indicatorCount {
      let circle = UIBezierPath(ovalIn: CGRect(x: 10 * i, y: 0, width: 6, height: 6))
      UIColor(red: 1, green: 1, blue: 1, alpha: 1).setFill()
      circle.fill()
    }
  }
  
  private func updateSize() {
    self.frame.size = CGSize(width: 10 * indicatorCount, height: 6)
    let superWidth = self.superview?.frame.width
    
    if isLeft {
      self.frame.origin = CGPoint(x: 5, y: 12)
    } else {
      self.frame.origin = CGPoint(x: superWidth! - CGFloat(10 * indicatorCount) - 1, y: 12)
    }
  }
  
  private func changeCountAnimation() {
    let layerPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 6, height: 6))
    let animationLayer = CAShapeLayer()
    animationLayer.path = layerPath.cgPath
    animationLayer.fillColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
    
    var toX: CGFloat = 0
    if isLeft {
      animationLayer.frame.origin = CGPoint(x: 10 * indicatorCount, y: 0)
      toX = UIScreen.main.bounds.size.width - 100
    } else {
      animationLayer.frame.origin = CGPoint(x: -10 * indicatorCount, y: 0)
      toX = 100 - UIScreen.main.bounds.size.width
    }
    
    self.layer.addSublayer(animationLayer)
    
    let moveAnimation = CABasicAnimation(keyPath: "position")
    let position = animationLayer.position
    moveAnimation.fromValue = NSValue(cgPoint: position)
    moveAnimation.toValue = NSValue(cgPoint: CGPoint(x: toX, y: position.y))
    moveAnimation.duration = 0.6
    moveAnimation.repeatCount = 1
    animationLayer.add(moveAnimation, forKey: "move")
    
    let opacityAnimation = CABasicAnimation(keyPath: "opacity")
    opacityAnimation.delegate = self
    opacityAnimation.fromValue = 1.0
    opacityAnimation.byValue = 0.2
    opacityAnimation.toValue = 0.0
    opacityAnimation.duration = 0.6
    opacityAnimation.repeatCount = 1
    opacityAnimation.fillMode = kCAFillModeForwards
    opacityAnimation.isRemovedOnCompletion = false
    animationLayer.add(opacityAnimation, forKey: "opacityLayer")
  }
  
  private func changeOpacityAnimation() {
    let opacityAnimation = CABasicAnimation(keyPath: "opacity")
    opacityAnimation.fromValue = 0.0
    opacityAnimation.toValue = 1.0
    opacityAnimation.duration = 1
    opacityAnimation.repeatCount = 1
    self.layer.add(opacityAnimation, forKey: "opacity")
  }
}

extension TTCarouselIndicator: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if self.layer.sublayers?.count != 0 && self.layer.sublayers != nil {
      for layer in self.layer.sublayers! {
        layer.removeFromSuperlayer()
      }
    }
    
    self.setNeedsDisplay()
  }
}
