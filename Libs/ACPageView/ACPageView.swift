//
//  ACPageView.swift
//  ACLibSwift
//
//  Created by 陈军 on 2017/5/28.
//  Copyright © 2017年 AaronChan. All rights reserved.
//

import UIKit

class ACPageView: UIView {

    // MARK: 定义属性
    fileprivate var titles : [String]
    fileprivate var childrenVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    fileprivate var titleStyle : ACPageStyle
    
    // MARK: 构造函数
    init(frame : CGRect, titles : [String], titleStyle : ACPageStyle, childrenViewControllers : [UIViewController], parentViewController : UIViewController) {
        
        self.titles = titles
        self.childrenVcs = childrenViewControllers
        self.parentVc = parentViewController
        self.titleStyle = titleStyle
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK:- 私有方法
extension ACPageView{

    //MARK:- 设置UI界面内容
    fileprivate func setupUI() {
        // 1.添加titleView到pageView中
        let titleViewFrame = CGRect(x: 0, y: 0, width: bounds.width, height: titleStyle.titleViewHeight)
        let titleView = ACTitleView(frame: titleViewFrame, titles: titles, style : titleStyle)
        addSubview(titleView)
        titleView.backgroundColor = titleStyle.titleViewBackground
        
        // 2.添加contentView到pageView中
        let contentViewFrame = CGRect(x: 0, y: titleView.frame.maxY, width: bounds.width, height: frame.height - titleViewFrame.height)
        let contentView = ACContentView(frame: contentViewFrame, childVcs: childrenVcs, parentVc: parentVc)
        addSubview(contentView)
        contentView.backgroundColor = UIColor.randomColor()
        
        // 3.设置contentView&titleView关系
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}
