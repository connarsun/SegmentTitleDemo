# SegmentTitleDemo

```
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var vcs = [UIViewController]()
        let titles = ["美女", "帅哥帅", "大美帅帅帅", "帅哥",
                      "帅帅帅帅帅帅帅哥", "帅帅帅帅哥", "帅帅帅帅",
                      "美", "帅", "大美帅帅帅帅帅帅", "帅帅哥",
                      "帅帅帅帅帅帅帅帅帅哥", "帅帅帅帅哥", "帅帅帅帅帅帅帅帅帅帅帅帅帅帅帅"]
        
        for _ in titles {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor
            vcs.append(vc)
        }

        let segmentView = SKSegmentView(frame: view.bounds,
                                        titles: titles,
                                        childViewControllers: vcs,
                                        parentViewController: self)
        segmentView.titleView.isNeedScale = false
        view.addSubview(segmentView)
    }
```
