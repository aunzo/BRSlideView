//
//  BRSlideView.swift
//
//  Created by Blackraito on 1/26/2560 BE.
//  Copyright © 2560 Patarapon Tokham. All rights reserved.

import UIKit

protocol BRSlideViewDataSource
{
    func numberOfSlideItems(in slideView: BRSlideView) -> Int
    func slideView(_ slideView: BRSlideView, titleForSlideItemsAt index: Int) -> String?
    func slideView(_ slideView: BRSlideView, viewControllerAt index: Int) -> UIViewController
}

protocol BRSlideViewDelegate
{
    func slideView(slideView: BRSlideView, didSelectItemAt index: Int)
}

extension BRSlideViewDelegate
{
    func slideView(slideView: BRSlideView, didSelectItemAt index: Int) { }
}

class BRSlideView: UIView
{
    private var slideViewHeight: CGFloat = 50
    
    private var slideBarHeight: CGFloat = 5
    
    private var slideRatio: CGFloat  = 1
    
    private let screenWidth = UIScreen.main.bounds.size.width
    
    private let screenHeight = UIScreen.main.bounds.size.height
    
    private var buttonArray = [UIButton]()
    
    private var childControllersArray = [UIViewController]()
    
    private var slideView: UIView?
    
    private var slideBarView: UIView!
    
    private var contentScrollView: UIScrollView?
    
    private var slideBarColor = #colorLiteral(red: 0.6352941176, green: 0.1411764706, blue: 0.1882352941, alpha: 1)
    
    private var titleColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    private var titleFont = UIFont.systemFont(ofSize: 16)
    
    private var numberOfSlideItems = 0
    
    private var titleOfSlideItems = [String]()
    
    var delegate: BRSlideViewDelegate!
    
    var dataSource: BRSlideViewDataSource!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit()
    {
        self.backgroundColor = .white
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.configureData()
        self.addSubView()
    }
    
    private func configureData()
    {
        self.numberOfSlideItems = self.dataSource.numberOfSlideItems(in: self)
        for i in 0..<self.numberOfSlideItems
        {
            self.titleOfSlideItems.append(self.dataSource.slideView(self, titleForSlideItemsAt: i) ?? "")
        }
    }
    
    private func addSubView()
    {
        self.addSlideBarView()
        self.addSlideView()
        self.addButtons()
        self.addContentScrollView()
    }
    
    private func addSlideView()
    {
        let slideItemWidth = self.screenWidth / CGFloat(self.numberOfSlideItems)
        let sliderWidth = slideItemWidth * self.slideRatio
        let positionX = (slideItemWidth - sliderWidth) / 2.0
        self.slideBarView.addSubview(self.slideViewWith(frame: CGRect(x: positionX, y: slideViewHeight - slideBarHeight, width: sliderWidth, height: slideBarHeight)))
    }
    
    private func addSlideBarView()
    {
        self.slideBarView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.slideViewHeight))
        self.slideBarView.backgroundColor = .white
        self.addSubview(self.slideBarView)
    }
    
    private func addButtons()
    {
        let numberOfItems = self.titleOfSlideItems.count
        let slideItemWidth = self.screenWidth / CGFloat(self.numberOfSlideItems)
        let sliderWidth = slideItemWidth * self.slideRatio
        let positionX = (slideItemWidth - sliderWidth) / 2.0
        
        for number in 0..<numberOfItems
        {
            self.slideBarView.addSubview(self.customBottonWith(frame: CGRect(x: positionX + slideItemWidth * CGFloat(number), y: 5, width: sliderWidth, height: 35), for: self.titleOfSlideItems[number], with: number))
        }
    }
    
    private func addContentScrollView()
    {
        self.contentScrollView = UIScrollView(frame: CGRect(x: 0, y: slideViewHeight, width: screenWidth, height: self.frame.size.height - slideViewHeight))
        self.contentScrollView?.isDirectionalLockEnabled = true
        self.contentScrollView?.backgroundColor = .white
        self.contentScrollView?.isPagingEnabled = true
        self.contentScrollView?.contentSize = CGSize(width: self.contentScrollView!.frame.size.width * CGFloat(self.numberOfSlideItems), height: 0)
        self.contentScrollView?.showsHorizontalScrollIndicator = false
        self.contentScrollView?.delegate = self
        self.contentScrollView?.bounces = true
        self.addSubview(self.contentScrollView!)
        
        for i in 0..<self.numberOfSlideItems
        {
            self.childControllersArray.append(self.dataSource.slideView(self, viewControllerAt: i))
        }
        
        for vc in self.childControllersArray
        {
            if let index = self.childControllersArray.index(of: vc)
            {
                vc.view.frame = CGRect(x: CGFloat(index) * screenWidth, y: 0, width: screenWidth, height: screenHeight - slideViewHeight)
                
                self.contentScrollView?.addSubview(vc.view)
            }
            
        }
        
    }
    
    //MARK :- Private Function
    private func customBottonWith(frame:CGRect, for title: String, with tag:Int) -> UIButton
    {
        let button = UIButton(type: .custom)
        button.frame = frame
        button.tag = tag
        button.setTitleColor(self.titleColor, for: .normal)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = self.titleFont
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(BRSlideView.buttonClicked(sender:)), for: .touchUpInside)
        
        if tag == 0
        {
            button.setTitleColor(self.slideBarColor, for: .normal)
        }
        
        self.buttonArray.append(button)
        
        return button
        
    }
    
    private func slideViewWith(frame: CGRect) -> UIView
    {
        if self.slideView == nil
        {
            self.slideView = UIView(frame: frame)
            self.slideView?.backgroundColor = self.slideBarColor
        }
        
        return self.slideView!
    }
    
    private func animateSlideViewWith(tag: Int)
    {
        self.contentScrollView?.setContentOffset(CGPoint(x: screenWidth * CGFloat(tag), y: 0), animated: true)
    }
    
    fileprivate func animateSlideViewToPositionWith(offset: CGPoint)
    {
        if let slider = self.slideView
        {
            let slideItemWidth = self.screenWidth / CGFloat(self.numberOfSlideItems)
            let sliderWidth = slideItemWidth * self.slideRatio
            let positionX = (slideItemWidth - sliderWidth) / 2.0
            let newFrame = CGRect(x: (offset.x / self.screenWidth) * slideItemWidth + positionX, y: slider.frame.origin.y, width: slider.frame.size.width, height: slider.frame.size.height)
            
            self.slideView?.frame = newFrame
            
            for button in self.buttonArray
            {
                button.setTitleColor(self.titleColor, for: .normal)
            }
            
            var buttonTag = 0
            let ratio = offset.x / self.screenWidth
            let decimal = ratio - floor(ratio)
            
            if decimal >= 0.5 && ratio > 0
            {
                buttonTag = Int(ratio) + 1
            }
            else
            {
                buttonTag = Int(ratio)
            }
            
            self.buttonArray[buttonTag].setTitleColor(self.slideView?.backgroundColor, for: .normal)
        }
    }
    
    fileprivate func endAnimateSlideViewToPositionWith(offset: CGPoint)
    {
        var buttonTag = 0
        let ratio = offset.x / self.screenWidth
        let decimal = ratio - floor(ratio)
        
        if decimal >= 0.5 && ratio > 0
        {
            buttonTag = Int(ratio) + 1
        }
        else
        {
            buttonTag = Int(ratio)
        }
        
        self.delegate?.slideView(slideView: self, didSelectItemAt: buttonTag)
    }
    
    @objc
    private func buttonClicked(sender: UIButton)
    {
        self.delegate?.slideView(slideView: self, didSelectItemAt: sender.tag)
        self.animateSlideViewWith(tag: sender.tag)
        self.contentScrollView?.setContentOffset(CGPoint(x: sender.tag * Int(self.screenWidth), y: 0), animated: true)
    }
    
    //MARK :- Configure Function
    func setTitleColor(color: UIColor)
    {
        self.titleColor = color
    }
    
    func setSlideBarColor(color: UIColor)
    {
        self.slideBarColor = color
    }
    
    func setSlideBarHeight(height:CGFloat)
    {
        self.slideBarHeight = height
    }
    
    func setSlideRatio(ratio:CGFloat)
    {
        self.slideRatio = ratio
    }
    
    func setSlideViewHeight(height:CGFloat)
    {
        self.slideViewHeight = height
    }
    
    func setTitleFont(font: UIFont)
    {
        self.titleFont = font
    }
}

extension BRSlideView:UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.animateSlideViewToPositionWith(offset: scrollView.contentOffset)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.endAnimateSlideViewToPositionWith(offset: scrollView.contentOffset)
    }
}
