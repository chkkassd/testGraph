//
//  SSFLineGraphView.swift
//  SSFGraph
//
//  Created by 赛峰 施 on 2018/5/18.
//  Copyright © 2018年 赛峰 施. All rights reserved.
//

import UIKit

class SSFLineGraphView: SSFBarGraphView, SSFLineGraphProtocol {
        
    private var drawPoints: [CGPoint]?
    
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
        drawPoints = lineGraph(diagram: diagram, rect: self.bounds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        guard let diagram = combinedDiagram, let points = drawPoints else {return}
        let context = UIGraphicsGetCurrentContext()
        context?.draw(diagram, in: rect)
        context?.draw(points: points)
    }
}

extension CGContext {
    func draw(points: [CGPoint]) {
        guard points.count > 0 else {return}
        saveGState()
        UIColor.black.set()
        self.move(to: points.first!)
        points.dropFirst().forEach {
            self.addLine(to: $0)
        }
        self.strokePath()
        restoreGState()
    }
}
