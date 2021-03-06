//
//  ViewController.swift
//  TTCarousel
//
//  Created by 李锐 on 2017/4/5.
//  Copyright © 2017年 李锐. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var carousel: TTCarousel!
  
  fileprivate let titles = ["Yukinoshita Yukino", "Hello world", "Before my body"]
  fileprivate let images = [UIImage(named: "img4"), UIImage(named: "img5"), UIImage(named: "img6")]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    carousel.dataSource = self
    carousel.autoChangeBackgroundColor = true
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension ViewController: TTCarouselDataSource {
  func numberOfPages(_ carouse: TTCarousel) -> Int {
    return 3
  }
  
  func pageTitle(currentIndex: Int) -> String {
    return titles[currentIndex]
  }
  
  func pageView(_ carouse: TTCarousel, pageSize: CGSize, pageIndex: Int) -> UIView {
    let view = UIView()
    let image = UIImageView(image: images[pageIndex])
    image.contentMode = .scaleAspectFill
    image.frame = CGRect(x: 0, y: 0, width: pageSize.width, height: pageSize.height)
    image.layer.cornerRadius = 5
    image.clipsToBounds = true
    
    view.addSubview(image)
    return view
  }
  
  func mainImage(pageIndex: Int) -> UIImage {
    return images[pageIndex]!
  }
}
