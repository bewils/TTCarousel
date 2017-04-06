//
//  TTCarouselIndicator.swift
//  TTCarousel
//
//  Created by 李锐 on 2017/4/5.
//  Copyright © 2017年 李锐. All rights reserved.
//

import UIKit

class TTCarouselIndicator: UIView {
  
  var indicatorCount = 0 {
    didSet {
      self.updateSize()
      self.setNeedsDisplay()
    }
  }
  var isLeft = true
  
  override func draw(_ rect: CGRect) {
    UIColor(red: 73 / 255, green: 144 / 255, blue: 226 / 255, alpha: 1).setFill()
    UIRectFill(rect)
    super.draw(rect)
    
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
      self.frame.origin = CGPoint(x: superWidth! - CGFloat(10 * indicatorCount) - 1, y: 6)
    }
  }
}
