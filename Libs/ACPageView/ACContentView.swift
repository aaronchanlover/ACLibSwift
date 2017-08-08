//
//  ACContentView.swift
//  ACLibSwift
//
//  Created by 陈军 on 2017/5/28.
//  Copyright © 2017年 AaronChan. All rights reserved.
//

import UIKit

private let kContentCellID = "kContentCellID"


protocol ACContentViewDelegate : class {
    func contentView(_ contentView : ACContentView, targetIndex : Int, progress : CGFloat)
    func contentView(_ contentView : ACContentView, endScroll inIndex : Int)
}

class ACContentView: UIView {

    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    
    fileprivate var scrollStartContentOffsetX : CGFloat = 0 
    fileprivate var isForbidDelegate : Bool = true
    
    weak var delegate : ACContentViewDelegate?
    
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        //用于collectionviewcell重用
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        
        return collectionView
    }()

    // MARK: 构造函数
    init(frame : CGRect, childVcs : [UIViewController], parentVc : UIViewController) {
        
        self.childVcs = childVcs
        self.parentVc = parentVc
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("不能从xib中加载")
    }
    

}

//MARK:- 私有方法
extension ACContentView{

    
    /// 初始化界面
    func setupUI()  {
        
        //1.将childVc添加到父控制器中
        for vc in childVcs{
            parentVc.addChildViewController(vc)
        }
        
        //2.初始化用于显示子控制器View的View（UIScrollView/UICollectionView）
        addSubview(collectionView)
    }
}

//MARK:- UICollectionViewDataSource代理实现
extension ACContentView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let vc = childVcs[indexPath.item]
        vc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(vc.view)
        
        return cell
    }

}



//MARK:- UICollectionViewDelegate代理实现
extension ACContentView : UICollectionViewDelegate{
    
    //减速停止的时候开始执行
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            collectionViewEndScroll()
    }
    
    //停止拖拽的时候开始执行
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            collectionViewEndScroll()
        }
    }
    
    private func collectionViewEndScroll() {
        // 1.获取结束时，对应的indexPath
        let endIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        
        // 2.通知titleView改变下标
        delegate?.contentView(self, endScroll: endIndex)
    }

    
    /// 开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 记住拖动起始位置
        isForbidDelegate = false
        scrollStartContentOffsetX = scrollView.contentOffset.x
    
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollStartContentOffsetX != scrollView.contentOffset.x || isForbidDelegate else{
            return
        }
        
        //1. 定义targetIndex/progress
        //targetIndex指的是内容view的index
        var targetIndex = 0
        var progress : CGFloat = 0.0
        
        
        //2. 给targetIndex/progress赋值
        //拖拽的起点x除以屏幕的宽度及可获得偏移的页数，即当前页（第一页从0开始）
        let currentIndex = Int(scrollStartContentOffsetX / scrollView.bounds.width)
        if scrollStartContentOffsetX < scrollView.contentOffset.x{
            //左滑
            targetIndex = currentIndex + 1
            if targetIndex > childVcs.count - 1{
                targetIndex = childVcs.count - 1
            }
            
            progress = (scrollView.contentOffset.x - scrollStartContentOffsetX )/scrollView.bounds.width
        }else{
            //右滑
            targetIndex = currentIndex - 1
            //判断是否越界
            if targetIndex < 0{
                targetIndex = 0
            }
            
            //进度= （最终的偏移量-开始拖拽的迁移量）/scrollview的宽度
            progress = (scrollStartContentOffsetX - scrollView.contentOffset.x)/scrollView.bounds.width
        }
        
        
        //3. 通知代理
        delegate?.contentView(self, targetIndex: targetIndex, progress: progress)
        
    }
}


//MARK:- ACTitleViewDelegate代理实现
extension ACContentView : ACTitleViewDelegate{

    func titleView(_ titleView: ACTitleView, didSelected currentIndex: Int) {
        isForbidDelegate = true
        
        let indexPath = IndexPath(item: currentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}
