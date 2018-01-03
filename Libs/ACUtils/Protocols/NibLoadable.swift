//
//  NibLoadable.swift
//  ACLibSwift
//
//  Created by 陈军 on 2017/11/12.
//  Copyright © 2017年 AaronChan. All rights reserved.
//

import UIKit

protocol NibLoadable {
    
}

extension NibLoadable where Self : UIView {
    
    ///在MainBundle中从Nib获取UIView
    ///
    /// - Returns: UIView或其子类
    static func loadFromMainNib()->Self{
        let bundle = Bundle.init(for: self)
        return bundle.loadNibNamed("\(self)", owner: nil, options: nil)?.first as! Self
    }
    
}
