//
//  SSFScatterGraphView.swift
//  SSFGraph
//
//  Created by 赛峰 施 on 2018/6/1.
//  Copyright © 2018年 赛峰 施. All rights reserved.
//

import UIKit

class SSFScatterGraphView: SSFBarGraphView, SSFScatterGraphViewProtocol {
    
    private var drawScatters: [(CGPoint, CGFloat)]?
    
    override var barColor: UIColor {
        get {
            return UIColor.clear
        }
        set {}
    }

    override var strokeColor: UIColor {
        get {
            return UIColor.clear
        }
        set {}
    }
    
    //sourceData's element is tuple type.(text, value),text represents the bar label,value represents the bar values.
    override public init(frame: CGRect, sourceData: [(String, Double)]) {
        super.init(frame: frame, sourceData: sourceData)
        guard let diagram = combinedDiagram else { return }
        drawScatters = scatterGraph(diagram: diagram, rect: self.bounds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        guard let diagram = combinedDiagram, let scatters = drawScatters else {return}
        let context = UIGraphicsGetCurrentContext()
        context?.draw(diagram, in: rect)
        context?.draw(scatters: scatters)
    }
}

extension CGContext {
    func draw(scatters: [(CGPoint, CGFloat)]) {
        guard scatters.count > 0 else {return}
        saveGState()
        UIColor.black.set()
        scatters.forEach { (point, radius) in
            fillEllipse(in: CGRect(x:point.x - radius/6 , y: point.y - radius/6, width: radius/3, height: radius/3))
        }
        restoreGState()
    }
}
