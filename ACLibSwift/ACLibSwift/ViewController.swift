//
//  ViewController.swift
//  ACLibSwift
//
//  Created by 陈军 on 2017/3/16.
//  Copyright © 2017年 AaronChan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scanresultLabel: UILabel!
    @IBOutlet weak var qrcodeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func QrCodeButtonDidClick(_ sender: Any) {
     
        self.present(QRCodeViewController(closure:{ [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.scanresultLabel.text=result
            }
        ), animated: true, completion: nil)
        
    }
    
    
    @IBAction func tabbarButonDidClick(_ sender: Any) {
        //        var tbc = ACTabBarController()
        
        //        let v1 = TabbarExampleViewController()
        //        let v2 = TabbarExampleViewController()
        //        let v3 = TabbarExampleViewController()
        //        let v4 = TabbarExampleViewController()
        //        let v5 = TabbarExampleViewController()
        //
        //        v1.tabBarItem = ACTabBarItem.init(title: "Home", image: UIImage(named: "tabBar_essence_icon"), selectedImage: UIImage(named: "tabBar_essence_click_icon"))
        //        v2.tabBarItem = ACTabBarItem.init(title: "Find", image: UIImage(named: "tabBar_friendTrends_icon"), selectedImage: UIImage(named: "tabBar_friendTrends_click_icon"))
        //        v3.tabBarItem = ACTabBarItem.init(title: nil, image: UIImage(named: "tabBar_new_icon"), selectedImage: UIImage(named: "tabBar_new_click_icon"))
        //        v4.tabBarItem = ACTabBarItem.init(title: "Favor", image: UIImage(named: "tabBar_me_icon"), selectedImage: UIImage(named: "tabBar_me_click_icon"))
        //        v5.tabBarItem = ACTabBarItem.init(title: "Me", image: UIImage(named: "tabBar_new_icon"), selectedImage: UIImage(named: "tabBar_new_click_icon"))
        //
        let tbc = ACTabBarController.init(tabBarItems: [(TabbarExample2ViewController(),ExampleBouncesContentView(),"Home", UIImage(named: "tabBar_essence_icon"), UIImage(named: "tabBar_essence_click_icon")),
                                                        (TabbarExampleViewController(),ExampleBouncesContentView(),"Home", UIImage(named: "tabBar_essence_icon"), UIImage(named: "tabBar_essence_click_icon")),
                                                        (TabbarExample2ViewController(),ExampleIrregularityContentView(),"Home", UIImage(named: "tabbar_photo_verybig"), UIImage(named: "tabbar_photo_verybig_click")),
                                                        (TabbarExampleViewController(),ExampleBouncesContentView(),"Home", UIImage(named: "tabBar_essence_icon"), UIImage(named: "tabBar_essence_click_icon")),
                                                        (TabbarExample2ViewController(),ExampleBouncesContentView(),"Home", UIImage(named: "tabBar_essence_icon"), UIImage(named: "tabBar_essence_click_icon"))])
        
        tbc.shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 2 {
                return true
            }
            return false
        }
        tbc.didHijackHandler = {
            [weak tabBarController] tbc, viewController, index in
            
            print("拦截了")
        }
        tbc.selectedIndex = 1
        //        tbc.viewControllers = [v1, v2, v3, v4, v5]
        self.navigationController?.pushViewController(tbc, animated: true)
        
    }
}

