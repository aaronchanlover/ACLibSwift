//
//  ACTabBarItemContainer.swift
//  AaronLibsForiOS
//
//  Created by 陈军 on 2017/3/14.
//  Copyright © 2017年 aaron. All rights reserved.
//

import UIKit

class ACTabBarItemContainer: UIControl {
    
    internal init(_ target: AnyObject?, tag: Int) {
        super.init(frame: CGRect.zero)
        self.tag = tag
        self.addTarget(target, action: #selector(ACTabBar.selectAction(_:)), for: .touchUpInside)
        self.addTarget(target, action: #selector(ACTabBar.highlightAction(_:)), for: .touchDown)
        self.addTarget(target, action: #selector(ACTabBar.highlightAction(_:)), for: .touchDragEnter)
        self.addTarget(target, action: #selector(ACTabBar.dehighlightAction(_:)), for: .touchDragExit)
        self.backgroundColor = .clear
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        for subview in self.subviews {
            if let subview = subview as? ACTabBarItemContentView {
                subview.frame = CGRect.init(x: subview.insets.left, y: subview.insets.top, width: bounds.size.width - subview.insets.left - subview.insets.right, height: bounds.size.height - subview.insets.top - subview.insets.bottom)
                subview.updateLayout()
            }
        }
    }
    
    internal override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var b = super.point(inside: point, with: event)
        if !b {
            for subview in self.subviews {
                if subview.point(inside: CGPoint.init(x: point.x - subview.frame.origin.x, y: point.y - subview.frame.origin.y), with: event) {
                    b = true
                }
            }
        }
        return b
    }
    
}
