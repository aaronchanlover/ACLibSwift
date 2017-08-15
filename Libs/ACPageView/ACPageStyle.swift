//
//  ACPageStyle.swift
//  ACLibSwift
//
//  Created by 陈军 on 2017/5/28.
//  Copyright © 2017年 AaronChan. All rights reserved.
//

import UIKit

class ACPageStyle {

    var titleViewHeight : CGFloat = 44
    var titleViewBackground: UIColor = UIColor(r : 239, g : 239, b : 239)
    var titleFont : UIFont = UIFont.systemFont(ofSize: 15.0)
    
    
    /// titleview是否可以滚动
    var isScrollEnable : Bool = false
    
    /// titleview中item的边距
    var titleMargin : CGFloat = 20
    

    /// titleview正常字体颜色
    var normalColor : UIColor = UIColor(r: 0, g: 0, b: 0)
    
    /// titleview选中字体颜色
    var selectedColor : UIColor = UIColor(r: 255, g: 127, b: 0)
    
    
    /// titleview中item的下划线
    var isShowBottomLine : Bool = true
    var bottomLineColor : UIColor = UIColor.orange
    var bottomLineHeight : CGFloat = 2
        
    /// 选中字体的缩放
    var isTitleScale : Bool = false
    var scaleRange : CGFloat = 1.1
    
    /// titleview中item的遮罩
    var isShowCoverView : Bool = false
    var coverBgColor : UIColor = UIColor.black
    var coverAlpha : CGFloat = 0.4
    var coverMargin : CGFloat = 8
    var coverHeight : CGFloat = 25

    
}
