//
//  SKTitleView.swift
//  segmentTitle
//
//  Created by sun on 2017/8/2.
//  Copyright © 2017年 sun. All rights reserved.
//

import UIKit

protocol SKTitleViewDelegate: class {
    func titleView(_ titleView: SKTitleView, selectedIndex: Int)
}

class SKTitleView: UIView {
    
    // MARK: - SKTitleViewDelegate
    weak var delegate: SKTitleViewDelegate?
    
    // MARK: - 底部滚动条
    /// 是否显示底部滚动条
    var isShowBottomLine: Bool = true
    /// 底部滚动条的颜色
    var bottomLineColor: UIColor = UIColor.orange
    /// 底部滚动条的高度
    var bottomLineH : CGFloat = 2
    
    // MARK: - Title
    /// 普通Title颜色(使用RGB)
    var normalColor : UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    /// 选中Title颜色(使用RGB)
    var selectedColor : UIColor = UIColor(red: 255 / 255.0, green: 127 / 255.0, blue: 0, alpha: 1.0)
    /// Title字体大小
    var titleFont : UIFont = UIFont.systemFont(ofSize: 14.0)
    /// 滚动Title的字体间距
    var titleMargin : CGFloat = 30
    /// 是否缩放
    var isNeedScale: Bool = true
    /// 缩放比例
    var scaleRange : CGFloat = 1.2
    
    // MARK: - 私有属性
    fileprivate var scrollView: UIScrollView!
    fileprivate var titles: [String]!
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    fileprivate var currentIndex: Int = 0
    
    fileprivate lazy var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = self.bottomLineColor
        return line
    }()
    
    fileprivate var normalColorRGB: (r: CGFloat, g: CGFloat, b: CGFloat) {
        return getRGB(self.normalColor)
    }
    fileprivate var selectedColorRGB: (r: CGFloat, g: CGFloat, b: CGFloat) {
        return getRGB(self.selectedColor)
    }
    
    init(frame: CGRect = CGRect.zero, titles: [String]) {
        super.init(frame: frame)
        self.titles = titles
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupUI()
        setupTitleLabels()
        setupTitleLabelsPosition()
        if isShowBottomLine {
            setupBottomLine()
        }
    }
}

// MARK: - UI相关
fileprivate extension SKTitleView {
    func setupUI() {
        scrollView = UIScrollView(frame: bounds)
        scrollView.backgroundColor = UIColor.gray
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        addSubview(scrollView)
    }
    
    func setupTitleLabels() {
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.tag = index
            label.textColor = index == 0 ? selectedColor : normalColor
            label.font = titleFont
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
            titleLabels.append(label)
            scrollView.addSubview(label)
        }
    }
    
    func setupTitleLabelsPosition() {
        var labelX: CGFloat = 0
        let labelY: CGFloat = 0
        var labelW: CGFloat = 0
        let labelH: CGFloat = frame.height
        
        for (index, label) in titleLabels.enumerated() {
            guard let text = label.text else { continue }
            /*
             let rect = (text as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0),
             options: .usesLineFragmentOrigin,
             attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15)],
             context: nil)
             */
            let size = (text as NSString).size(attributes: [NSFontAttributeName: titleFont])
            labelW = size.width + titleMargin
            if index != 0 {
                labelX = titleLabels[index - 1].frame.maxX
            } else {
                let scale = isNeedScale ? scaleRange : 1
                label.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
            
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
        }
        
        scrollView.contentSize = CGSize(width: titleLabels.last!.frame.maxX, height: 0)
    }
    
    func setupBottomLine() {
        scrollView.addSubview(bottomLine)
        bottomLine.frame = titleLabels.first!.frame
        bottomLine.frame.size.height = bottomLineH
        bottomLine.frame.origin.y = bounds.height - bottomLineH
    }
    
    func getRGB(_ color: UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard let componets = color.cgColor.components else {
            fatalError("请使用RGB方式赋值")
        }
        return (componets[0], componets[1], componets[2])
    }
}

// MARK: - 点击事件
extension SKTitleView {
    @objc fileprivate func titleLabelClick(_ tap: UITapGestureRecognizer) {
        guard let currentLabel = tap.view as? UILabel else { return }
        if currentLabel.tag == currentIndex { return }
        
        let preLabel = titleLabels[currentIndex]
        preLabel.textColor = normalColor
        currentLabel.textColor = selectedColor
        
        currentIndex = currentLabel.tag

        delegate?.titleView(self, selectedIndex: currentIndex)
        
        contentViewScroll()
        
        if isShowBottomLine {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.origin.x = currentLabel.frame.origin.x
                self.bottomLine.frame.size.width = currentLabel.frame.size.width
            })
        }
        
        if isNeedScale {
            preLabel.transform = CGAffineTransform.identity
            currentLabel.transform = CGAffineTransform(scaleX: scaleRange, y: scaleRange)
        }
    }
}

// MARK: - 外界调用
extension SKTitleView {
    func setTitle(_ progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        let colorDiff: (r: CGFloat, g: CGFloat, b: CGFloat) = (selectedColorRGB.r - normalColorRGB.r,
                                                               selectedColorRGB.g - normalColorRGB.g,
                                                               selectedColorRGB.b - normalColorRGB.b)
        sourceLabel.textColor = UIColor(red: selectedColorRGB.r - colorDiff.r * progress,
                                        green: selectedColorRGB.g - colorDiff.g * progress,
                                        blue: selectedColorRGB.b - colorDiff.b * progress,
                                        alpha: 1.0)
        
        targetLabel.textColor = UIColor(red: normalColorRGB.r + colorDiff.r * progress,
                                        green: normalColorRGB.g + colorDiff.g * progress,
                                        blue: normalColorRGB.b + colorDiff.b * progress,
                                        alpha: 1.0)
        currentIndex = targetIndex
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveTotalW = targetLabel.frame.width - sourceLabel.frame.width
        
        if isShowBottomLine {
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + moveTotalX * progress
            bottomLine.frame.size.width = sourceLabel.frame.width + moveTotalW * progress
        }
        if isNeedScale {
            let scaleDiff = (scaleRange - 1) * progress
            sourceLabel.transform = CGAffineTransform(scaleX: scaleRange - scaleDiff,
                                                      y: scaleRange - scaleDiff)
            targetLabel.transform = CGAffineTransform(scaleX: 1 + scaleDiff,
                                                      y: 1 + scaleDiff)
        }
    }
    
    func contentViewScroll() {
        let targetLabel = titleLabels[currentIndex]
        var offsetX = targetLabel.center.x - bounds.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        
        let maxOffset = scrollView.contentSize.width - bounds.width
        if offsetX > maxOffset {
            offsetX = maxOffset
        }
        if scrollView.contentSize.width > bounds.width {
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }
}
