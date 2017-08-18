//
//  SKSegmentView.swift
//  segmentTitle
//
//  Created by sun on 2017/8/6.
//  Copyright © 2017年 sun. All rights reserved.
//

import UIKit

class SKSegmentView: UIView {

    var titleView: SKTitleView!
    fileprivate var titles: [String]!
    fileprivate var contentView: SKContentView!

    fileprivate var childViewControllers: [UIViewController]!
    fileprivate var parentViewController: UIViewController!
    
    init(frame: CGRect, titles: [String], childViewControllers: [UIViewController], parentViewController: UIViewController) {
        super.init(frame: frame)
        
        assert(titles.count == childViewControllers.count, "titles和childViewControllers个数不同，请检查！！")
        self.titles = titles
        self.childViewControllers = childViewControllers
        self.parentViewController = parentViewController
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SKSegmentView {
    fileprivate func setupUI() {
        let titleH : CGFloat = 40
        let titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: titleH)
        titleView = SKTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        addSubview(titleView)
        
        let contentFrame = CGRect(x: 0, y: titleH, width: frame.width, height: frame.height - titleH)
        contentView = SKContentView(frame: contentFrame, childViewControllers: childViewControllers, parentViewController: parentViewController)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.delegate = self
        addSubview(contentView)
    }
}

extension SKSegmentView: SKTitleViewDelegate {
    func titleView(_ titleView: SKTitleView, selectedIndex: Int) {
        contentView.setCurrentIndex(selectedIndex)
    }
}

extension SKSegmentView: SKContentViewDelegate {
    func contentView(_ contentView: SKContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitle(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func contentViewEndScroll(_ contentView: SKContentView) {
        titleView.contentViewScroll()
    }
}

