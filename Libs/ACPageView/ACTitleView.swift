//
//  ACTitleView.swift
//  ACLibSwift
//
//  Created by 陈军 on 2017/5/28.
//  Copyright © 2017年 AaronChan. All rights reserved.
//

import UIKit

protocol ACTitleViewDelegate : class {
    
    func titleView(_ titleView : ACTitleView, didSelected currentIndex : Int)
    
}


class ACTitleView: UIView {
    
    fileprivate var titles : [String]
    fileprivate var style : ACPageStyle
    
    // MARK: 定义属性
    weak var delegate : ACTitleViewDelegate?

    
    fileprivate lazy var currentIndex : Int = 0
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        //设置点击状态不回到顶部
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    //标题底线
    
    
    init(frame : CGRect, titles : [String], style : ACPageStyle) {
        self.titles = titles
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- 私有方法
extension ACTitleView{

    
    /// 初始化界面
    fileprivate func setupUI(){
    
        // 1.添加滚动view
        addSubview(scrollView)
        
        // 2.添加title对应的label
        setupTitleLabels()
        
        // 3.设置Label的frame
        setupTitleLabelsFrame()
        
        // 4.设置BottomLine
        setupBottomLine()
        
        // 5.设置CoverView
        setupCoverView()

    }
    
    fileprivate func setupTitleLabels(){
        
        for (i, title) in titles.enumerated() {
            // 1.创建Label
            let titleLabel = UILabel()
            
            // 2.设置label的属性
            titleLabel.text = title
            titleLabel.tag = i
            titleLabel.font = style.titleFont
            titleLabel.textColor = i == 0 ? style.selectedColor : style.normalColor
            titleLabel.textAlignment = .center
            
            // 3.添加到父控件中
            scrollView.addSubview(titleLabel)
            
            // 4.保存label
            titleLabels.append(titleLabel)
            
            // 5.添加手势
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            titleLabel.addGestureRecognizer(tapGes)
            titleLabel.isUserInteractionEnabled = true
        }
    }
    
    
    /// 设置标题的frame方法
    /// shezhi
    fileprivate func setupTitleLabelsFrame(){
        let count = titleLabels.count
        
        for(i,label) in titleLabels.enumerated(){
            var w : CGFloat = 0
            let h : CGFloat = bounds.height
            var x : CGFloat = 0
            let y : CGFloat = 0
            
            if !style.isScrollEnable{
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
            }
            else{
                
                w = (titles[i] as NSString).boundingRect(with: CGSize(width : CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes:[NSAttributedStringKey.font: style.titleFont] , context: nil).width
                if i == 0 {
                    x = style.titleMargin
                }
                else {
                    let preLabel = titleLabels[i - 1]
                    x = preLabel.frame.maxX + style.titleMargin
                }
            }
            
            label.frame = CGRect(x: x, y: y, width: w, height: h)
            
            if style.isTitleScale && i == 0 {
                label.transform = CGAffineTransform(scaleX: style.scaleRange, y: style.scaleRange)
            }

        }
        
        //如果标题是可以滚动的，则最后留白
        if style.isScrollEnable {
            scrollView.contentSize.width = titleLabels.last!.frame.maxX + style.titleMargin * 0.5
        }

        
    }
    
    fileprivate func setupBottomLine(){
    
    }
    
    fileprivate func setupCoverView(){
    
    }
}



//MARK:- 事件处理函数
extension ACTitleView{
    @objc fileprivate func titleLabelClick(_ tapGes : UITapGestureRecognizer){
        // 0.取出点击的Label
        guard  let newLabel = tapGes.view as? UILabel else {
            return
        }
        
        // 1.改变自身的titleLabel颜色
        let oldLabel = titleLabels[currentIndex]
        oldLabel.textColor = style.normalColor
        newLabel.textColor = style.selectedColor
        currentIndex = newLabel.tag
        
        
        //调整内容的位置
        adjustPosition(newLabel)
        
        // 2.通知内容view改变当前的位置
        delegate?.titleView(self, didSelected: currentIndex)
        
        
//        // 0.取出点击的Label
//        guard let newLabel = tapGes.view as? UILabel else { return }
//
//        // 1.改变自身的titleLabel的颜色
//        let oldLabel = titleLabels[currentIndex]
//        oldLabel.textColor = style.normalColor
//        newLabel.textColor = style.selectColor
//        currentIndex = newLabel.tag
//
//        // 2.通知内容View改变当前的位置
//        delegate?.titleView(self, didSelected: currentIndex)
//
//        // 3.调整BottomLine
//        if style.isShowBottomLine {
//            bottomLine.frame.origin.x = newLabel.frame.origin.x
//            bottomLine.frame.size.width = newLabel.frame.width
//        }
//
//        // 4.调整缩放比例
//        if style.isTitleScale {
//            newLabel.transform = oldLabel.transform
//            oldLabel.transform = CGAffineTransform.identity
//        }
//
//        // 5.调整位置
//        adjustPosition(newLabel)
//
//        // 6.调整coverView的位置
//        if style.isShowCoverView {
//            let coverW = style.isScrollEnable ? (newLabel.frame.width + style.titleMargin) : (newLabel.frame.width - 2 * style.coverMargin)
//            coverView.frame.size.width = coverW
//            coverView.center = newLabel.center
//        }

    }
}


//MARK:- ACContentViewDelegate的实现
extension ACTitleView : ACContentViewDelegate{
    
    ///内容页滚动
    func contentView(_ contentView: ACContentView, endScroll inIndex: Int) {
        // 1.取出两个Label
        let oldLabel = titleLabels[currentIndex]
        let newLabel = titleLabels[inIndex]
        
        // 2.改变文字的颜色
        oldLabel.textColor = style.normalColor
        newLabel.textColor = style.selectedColor
        
        // 3.记录最新的index
        currentIndex = inIndex
        
        // 4.判断是否可以滚动
        adjustPosition(newLabel)
    }
    
    //调整选中titleview的位置
    func adjustPosition(_ label : UILabel)  {
        //如果不能滚动则返回
        guard style.isScrollEnable else { return }
        
        //需调整的label的中心点-减去屏幕的一半（将label放在屏幕中间）
        //如果大于0则为实际的偏移值
        //如果小于0则不需要偏移
        var offsetX = label.center.x - scrollView.bounds.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }

        //如果偏移的宽度比 scrollview的内容宽度-屏幕宽度还要大，那么直接设置为偏移最大值
        let maxOffset = scrollView.contentSize.width - bounds.width
        if offsetX > maxOffset {
            offsetX = maxOffset
        }
        
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    ///内容页拖动
    func contentView(_ contentView: ACContentView, targetIndex: Int, progress: CGFloat) {
        
        // 1、取出label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        // 2、颜色渐变
        let deltaRGB = UIColor.getRGBDelta(style.selectedColor,style.normalColor)
        let selectedRGB = style.selectedColor.getRGB()
        let normalRGB = style.normalColor.getRGB()
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        
        sourceLabel.textColor = UIColor(r: selectedRGB.0 - deltaRGB.0 * progress, g: selectedRGB.1 - deltaRGB.1 * progress, b: selectedRGB.2 - deltaRGB.2 * progress)
        
    }
    
    
}
