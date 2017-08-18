//
//  ViewController.swift
//  SegmentTitleDemo
//
//  Created by sun on 2017/8/18.
//  Copyright © 2017年 sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var vcs = [UIViewController]()
        let titles = ["美女", "帅哥帅", "大美帅帅帅", "帅哥", "帅帅帅帅帅帅帅哥", "帅帅帅帅哥", "帅帅帅帅", "美", "帅", "大美帅帅帅帅帅帅", "帅帅哥", "帅帅帅帅帅帅帅帅帅哥", "帅帅帅帅哥", "帅帅帅帅帅帅帅帅帅帅帅帅帅帅帅"]
        
        for _ in titles {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor
            vcs.append(vc)
        }
        
        let segmentView = SKSegmentView(frame: CGRect(x: 0, y: 20, width: view.bounds.width, height: view.bounds.height - 20), titles: titles, childViewControllers: vcs, parentViewController: self)
        segmentView.titleView.isNeedScale = false
        view.addSubview(segmentView)
    }
}


extension UIColor {
    
    // MARK:- 随机颜色
    open class var randomColor:UIColor {
        get {
            let red = CGFloat(arc4random() % 256) / 255.0
            let green = CGFloat(arc4random() % 256) / 255.0
            let blue = CGFloat(arc4random() % 256) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

