//
//  UIImage+MainColor.swift
//  TTCarousel
//
//  Created by 李锐 on 2017/4/17.
//  Copyright © 2017年 李锐. All rights reserved.
//

import UIKit
import CoreGraphics

extension UIImage {
  func mainColor() -> UIColor? {
    // make image scale to 50 * 50
    let newSize = CGSize(width: 50, height: 50)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(data: nil, width: Int(newSize.width), height: Int(newSize.height), bitsPerComponent: 8, bytesPerRow: Int(newSize.width) * 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
    
    let drawRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    context?.draw(self.cgImage!, in: drawRect)
    
    guard let data = context?.data else {
      return nil
    }
    
    // store all colors in image
    let set = NSCountedSet(capacity: Int(newSize.width * newSize.height))
    for x in 1...Int(newSize.width) {
      for y in 1...Int(newSize.height) {
        let offset = 4 * ((Int(newSize.width)) * x + y)
        
        let color = data.advanced(by: offset).load(as: UInt32.self)
        let r = Int((color >> 24) & 0xff)
        let g = Int((color >> 16) & 0xff)
        let b = Int((color >> 8) & 0xff)
        
        set.add(NSArray(array: [r, g, b]))
      }
    }
    
    // find which color is main
    var maxCount = 0
    var mainColor: [Int] = []
    for color in set {
      let colorArray = (color as! NSArray) as! [Int]
      let allColor = colorArray[0] + colorArray[1] + colorArray[2]
      if allColor <= 200 || allColor >= 625 {
        continue
      }
      
      let count = set.count(for: color)
      if count > maxCount {
        maxCount = count
        mainColor = colorArray
      }
    }
    
    return UIColor(red: CGFloat(mainColor[0]) / 255, green: CGFloat(mainColor[1]) / 255, blue: CGFloat(mainColor[2]) / 255, alpha: 1)
  }
}
