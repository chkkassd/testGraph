//
//  ViewController.swift
//  SSFGraph
//
//  Created by 赛峰 施 on 2018/5/9.
//  Copyright © 2018年 赛峰 施. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var graphView : SSFBarGraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = [("Shanghai", 2500.0),("Beijing", 3200.0),("Houston", 300.0),("New York", 1500.0),("Berlin", 1400.0)]
        graphView = SSFBarGraphView(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 400), sourceData: data)
        graphView.barColor = UIColor.green
        graphView.textColor = UIColor.red
        graphView.textFont = UIFont.systemFont(ofSize: 16)
        self.view.addSubview(graphView)
    }
    
    @IBAction func viewWidthChanged(_ sender: UISlider) {
        let width = Double(Float(UIScreen.main.bounds.width) * sender.value)
        graphView.frame = CGRect(x: 0.0, y: 50.0, width: width, height: 400.0)
        graphView.setNeedsDisplay()
    }
}

