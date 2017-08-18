//
//  SKContentView.swift
//  segmentTitle
//
//  Created by sun on 2017/8/6.
//  Copyright © 2017年 sun. All rights reserved.
//

import UIKit

protocol SKContentViewDelegate: class {
    func contentView(_ contentView : SKContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
    func contentViewEndScroll(_ contentView : SKContentView)
}

private let kContentCellID = "kContentCellID"

class SKContentView: UIView {
    
    weak var delegate: SKContentViewDelegate?
    
    fileprivate var childViewControllers: [UIViewController]!
    fileprivate var parentViewController: UIViewController!
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var isCilckEnvent: Bool = false
    /**
    fileprivate var contentArr: [UIViewController] {
        get {
            guard let childViewControllers = childViewControllers else {
                return [UIViewController]()
            }
            return childViewControllers
        }
    } **/
    
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        return collectionView
    }()
    
    
    init(frame: CGRect = CGRect.zero, childViewControllers: [UIViewController], parentViewController: UIViewController) {
        super.init(frame: frame)
    
        self.childViewControllers = childViewControllers
        self.parentViewController = parentViewController
        
        for controller in childViewControllers {
            parentViewController.addChildViewController(controller)
        }
        
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SKContentView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childViewControllers.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        let childController = childViewControllers[indexPath.item]
        childController.view.frame = cell.contentView.frame
        cell.contentView.addSubview(childController.view)
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.contentViewEndScroll(self)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isCilckEnvent = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 是否是点击事件
        if isCilckEnvent { return }
        
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX { // 左滑
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            targetIndex = sourceIndex + 1
            if targetIndex >= childViewControllers.count {
                targetIndex = childViewControllers.count - 1
            }
            
            // 如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else { // 右滑
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            sourceIndex = targetIndex + 1
            if sourceIndex >= childViewControllers.count {
                sourceIndex = childViewControllers.count - 1
            }
        }
        
        delegate?.contentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

extension SKContentView {
    func setCurrentIndex(_ currentIndex : Int) {
        isCilckEnvent = true
        
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}

