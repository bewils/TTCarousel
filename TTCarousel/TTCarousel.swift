//
//  TTCarousel.swift
//  TTCarousel
//
//  Created by 李锐 on 2017/4/5.
//  Copyright © 2017年 李锐. All rights reserved.
//

import UIKit

class TTCarousel: UIView {
  
  // title items
  var titleLabel: UILabel?
  fileprivate var leftIndicator: TTCarouselIndicator?
  fileprivate var rightIndicator: TTCarouselIndicator?
  // main item
  var scrollView: UIScrollView?
  
  fileprivate var currentIndex = 0
  fileprivate var pageCount: Int?
  var dataSource: TTCarouselDataSource? {
    didSet {
      loadData()
    }
  }
  
  // 两块 page 间距
  var pageSpace: CGFloat = 12
  // 屏幕左右剪裁的大小
  var clipWidth: CGFloat = 26
  
  // 从 storyboard 初始化控件
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.updateConstraints()
    // 初始化 scroll view
    initScrollViews()
    // 初始化 title
    initTitleLabel()
    // 初始化左右指示器
    initIndicator()
  }
  
  private func initScrollViews() {
    scrollView = UIScrollView()
    scrollView?.delegate = self
    scrollView?.translatesAutoresizingMaskIntoConstraints = false
    scrollView?.showsHorizontalScrollIndicator = false
    self.addSubview(scrollView!)
    // 宽度和屏幕相等，高度留下 30 给顶部的 title 和 indicator
    let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: [:], views: ["view": scrollView!])
    let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(space)-[view]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["space": 30], views: ["view": scrollView!])
    self.addConstraints(hConstraints)
    self.addConstraints(vConstraints)
  }
  
  private func initTitleLabel() {
    titleLabel = UILabel()
    titleLabel?.translatesAutoresizingMaskIntoConstraints = false
    titleLabel?.textColor = UIColor.white
    titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    self.addSubview(titleLabel!)
    // 高度 30，居中，放到最顶部
    self.addConstraints([
      NSLayoutConstraint(item: titleLabel!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 30),
      NSLayoutConstraint(item: titleLabel!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: titleLabel!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
      ])
  }
  
  private func initIndicator() {
    // 初始状态没有宽度
    leftIndicator = TTCarouselIndicator(frame: CGRect(x: 5, y: 12, width: 0, height: 6))
    rightIndicator = TTCarouselIndicator(frame: CGRect(x: self.frame.width - 5, y: 12, width: 0, height: 6))
    rightIndicator?.isLeft = false
    
    leftIndicator?.translatesAutoresizingMaskIntoConstraints = false
    rightIndicator?.translatesAutoresizingMaskIntoConstraints = false
    
    self.addSubview(leftIndicator!)
    self.addSubview(rightIndicator!)
  }
  
  // 设置代理即载入数据
  private func loadData() {
    // 判断 page 数量
    if let pageCount = dataSource?.numberOfPages(self) {
      // 设置 page 的宽度
      let pageWidth = self.frame.width - 2 * (pageSpace + clipWidth)
      let width = 2 * (pageSpace + clipWidth) + CGFloat(pageCount) * pageWidth + CGFloat(pageCount - 1) * pageSpace
      let height = self.frame.height
      scrollView?.contentSize = CGSize(width: width, height: height - 60)
      
      self.pageCount = pageCount
      for i in 1...pageCount {
        let view = dataSource?.pageView(self, pageSize: CGSize(width: pageWidth, height: height - 60), pageIndex: i)
        view?.translatesAutoresizingMaskIntoConstraints = false
        let space = 38 + pageWidth * CGFloat(i - 1) + 12 * CGFloat(i - 1)
        
        view?.layer.cornerRadius = 5
        view?.layer.shadowColor = UIColor.black.cgColor
        view?.layer.shadowOffset = CGSize(width: 0, height: 0)
        view?.layer.shadowRadius = 5
        view?.layer.shadowOpacity = 0.4
        
        self.scrollView?.addSubview(view!)
        view?.frame = CGRect(x: space, y: 10, width: pageWidth, height: height - 60)
      }
      
      updateTopItems(index: 0)
      scrollView?.contentOffset = CGPoint(x: 0, y: 0)
    }
  }
  
  fileprivate func updateTopItems(index: Int) {
    titleLabel?.text = dataSource?.pageTitle(currentIndex: index)
    leftIndicator?.indicatorCount = index
    rightIndicator?.indicatorCount = pageCount! - 1 - index
  }
}

protocol TTCarouselDataSource {
  func numberOfPages(_ carouse: TTCarousel) -> Int
  func pageTitle(currentIndex: Int) -> String
  func pageView(_ carouse: TTCarousel, pageSize: CGSize, pageIndex: Int) -> UIView
}

extension TTCarousel: UIScrollViewDelegate {
  // 每次翻一页的距离
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    guard (velocity.x > 0 && currentIndex < pageCount! - 1) || (velocity.x < 0 && currentIndex > 0) else {
      return
    }
    
    if velocity.x > 0 {
      currentIndex +=  1
    } else {
      currentIndex -= 1
    }
    
    let width = self.frame.width - 2 * (pageSpace + clipWidth)
    targetContentOffset.pointee.x = (width + pageSpace) * CGFloat(currentIndex)
    
    updateTopItems(index: currentIndex)
    
    titleLabel?.alpha = 0
    UIView.animate(withDuration: 1) { [weak self] in
      self!.titleLabel?.alpha = 1
    }
  }
}
