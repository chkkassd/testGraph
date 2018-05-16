//
//  GraphView.swift
//  SSFGraph
//
//  Created by 赛峰 施 on 2018/5/16.
//  Copyright © 2018年 赛峰 施. All rights reserved.
//

import UIKit

class GraphView: UIView {


    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let blueSquare = Diagram.square(side: 60).filled(UIColor.blue)
        let greenRectangle = Diagram.rect(width: 30, height: 30).filled(UIColor.green)
        let combinedDiagram = blueSquare|||greenRectangle
        context?.draw(combinedDiagram, in: rect)
    }

}
