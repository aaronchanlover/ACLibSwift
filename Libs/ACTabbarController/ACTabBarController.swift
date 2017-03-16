//
//  ACTabbarController.swift
//  AaronLibsForiOS
//
//  Created by 陈军 on 2017/3/13.
//  Copyright © 2017年 aaron. All rights reserved.
//
/*
 仿造ESTabBarController
 */


import UIKit


/// 是否需要自定义点击事件回调类型
public typealias ACTabBarControllerShouldHijackHandler = ((_ tabBarController: UITabBarController, _ viewController: UIViewController, _ index: Int) -> (Bool))
/// 自定义点击事件回调类型
public typealias ACTabBarControllerDidHijackHandler = ((_ tabBarController: UITabBarController, _ viewController: UIViewController, _ index: Int) -> (Void))

open class ACTabBarController: UITabBarController {
    
    /// 打印异常
    open static func printError(_ description: String) {
        #if DEBUG
            print("ERROR: ACTabBarController catch an error '\(description)' \n")
        #endif
    }
    
    ///初始化tabbarcontroller
    public convenience init(tabBarItems : [(redirectController : UIViewController , title: String?, image: UIImage?, selectedImage :UIImage?)]){
        self.init()
        var tabBarControllers : Array<UIViewController>?=[]
        for item in tabBarItems{
            item.redirectController.tabBarItem = ACTabBarItem.init(title: item.title, image: item.image, selectedImage: item.selectedImage)
            tabBarControllers?.append(item.redirectController)
        }
        viewControllers=tabBarControllers
    }
    
    ///初始化tabbarcontroller
    public convenience init(tabBarItems : [(redirectController : UIViewController ,tabbarItemContentView :ACTabBarItemContentView, title: String?, image: UIImage?, selectedImage :UIImage?)]){
        self.init()
        
        var tabBarControllers : Array<UIViewController>?=[]
        //初始化tabbaritem
        for item in tabBarItems{
            item.redirectController.tabBarItem = ACTabBarItem.init(item.tabbarItemContentView,title: item.title, image: item.image, selectedImage: item.selectedImage)
            tabBarControllers?.append(item.redirectController)
        }
        //将tabbaritem赋给tabbarcontroller
        viewControllers=tabBarControllers
    }

    
    /// 当前tabBarController是否存在"More"tab
    open static func isShowingMore(_ tabBarController: UITabBarController?) -> Bool {
        return tabBarController?.moreNavigationController.parent != nil
    }
    
    /// Ignore next selection or not.
    fileprivate var ignoreNextSelection = false
    
    /// Should hijack select action or not.
    ///是否可以劫持的action
    open var shouldHijackHandler: ACTabBarControllerShouldHijackHandler?
    /// Hijack select action.
    open var didHijackHandler: ACTabBarControllerDidHijackHandler?
    
    /// Observer tabBarController's selectedViewController. change its selection when it will-set.
    open override var selectedViewController: UIViewController? {
        willSet {
            guard let newValue = selectedViewController else {
                return
            }
            guard !ignoreNextSelection else {
                ignoreNextSelection = false
                return
            }
            guard let tabBar = self.tabBar as? ACTabBar, let items = tabBar.items, let index = viewControllers?.index(of: newValue) else {
                return
            }
            let value = (ACTabBarController.isShowingMore(self) && index > items.count - 1) ? items.count - 1 : index
            tabBar.select(itemAtIndex: value, animated: false)
        }
    }
    
    /// Observer tabBarController's selectedIndex. change its selection when it will-set.
    open override var selectedIndex: Int {
        willSet {
            guard !ignoreNextSelection else {
                ignoreNextSelection = false
                return
            }
            guard let tabBar = self.tabBar as? ACTabBar, let items = tabBar.items else {
                return
            }
            let value = (ACTabBarController.isShowingMore(self) && newValue > items.count - 1) ? items.count - 1 : newValue
            tabBar.select(itemAtIndex: value, animated: false)
        }
    }
    
    /// Customize set tabBar use KVC.
    open override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = { () -> ACTabBar in
            let tabBar = ACTabBar()
            tabBar.delegate = self
            tabBar.customDelegate = self
            tabBar.tabBarController = self
            return tabBar
        }()
        self.setValue(tabBar, forKey: "tabBar")
    }
    
   
    // MARK: - ACTabBar delegate
    internal func tabBar(_ tabBar: UITabBar, shouldSelect item: UITabBarItem) -> Bool {
        if let idx = tabBar.items?.index(of: item), let vc = viewControllers?[idx] {
            return delegate?.tabBarController?(self, shouldSelect: vc) ?? true
        }
        return true
    }
    
    internal func tabBar(_ tabBar: UITabBar, shouldHijack item: UITabBarItem) -> Bool {
        if let idx = tabBar.items?.index(of: item), let vc = viewControllers?[idx] {
            return shouldHijackHandler?(self, vc, idx) ?? false
        }
        return false
    }
    
    internal func tabBar(_ tabBar: UITabBar, didHijack item: UITabBarItem) {
        if let idx = tabBar.items?.index(of: item), let vc = viewControllers?[idx] {
            didHijackHandler?(self, vc, idx)
        }
    }
    
}

extension ACTabBarController : ACTabBarDelegate{
    
    // MARK: - UITabBar delegate
    open override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.index(of: item) else {
            return;
        }
        if idx == tabBar.items!.count - 1, ACTabBarController.isShowingMore(self) {
            ignoreNextSelection = true
            selectedViewController = moreNavigationController
            return;
        }
        if let vc = viewControllers?[idx] {
            ignoreNextSelection = true
            selectedIndex = idx
            delegate?.tabBarController?(self, didSelect: vc)
        }
    }
    
    open override func tabBar(_ tabBar: UITabBar, willBeginCustomizing items: [UITabBarItem]) {
        if let tabBar = tabBar as? ACTabBar {
            tabBar.updateLayout()
        }
    }
    
    open override func tabBar(_ tabBar: UITabBar, didEndCustomizing items: [UITabBarItem], changed: Bool) {
        if let tabBar = tabBar as? ACTabBar {
            tabBar.updateLayout()
        }
    }
    
}
