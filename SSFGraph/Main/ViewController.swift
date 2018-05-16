//
//  ViewController.swift
//  SSFGraph
//
//  Created by 赛峰 施 on 2018/5/9.
//  Copyright © 2018年 赛峰 施. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var graphView : GraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graphView = GraphView(frame: CGRect(x: 0, y: 50, width: 400, height: 100))
        self.view.addSubview(graphView)
    }
    
    @IBAction func viewWidthChanged(_ sender: UISlider) {
        let width = Double(400.0 * sender.value)
        graphView.frame = CGRect(x: 0.0, y: 50.0, width: width, height: 100.0)
        graphView.setNeedsDisplay()
    }
}

