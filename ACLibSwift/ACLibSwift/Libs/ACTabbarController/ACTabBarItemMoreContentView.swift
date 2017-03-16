//
//  ACTabBarItemMoreContentView.swift
//  AaronLibsForiOS
//
//  Created by 陈军 on 2017/3/14.
//  Copyright © 2017年 aaron. All rights reserved.

import UIKit

open class ACTabBarItemMoreContentView: ACTabBarItemContentView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.title = "More"
        self.image = UIImage(named: "more")
        self.selectedImage = UIImage(named: "more_1")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
