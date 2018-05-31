//
//  SSFLineGraphView.swift
//  SSFGraph
//
//  Created by 赛峰 施 on 2018/5/18.
//  Copyright © 2018年 赛峰 施. All rights reserved.
//

import UIKit

class SSFLineGraphView: UIView, SSFLineGraphProtocol {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var combinedDiagram: (Diagram, [CGPoint])?
    
    //sourceData's element is tuple type.(text, value),text represents the bar label,value represents the bar values.
    convenience public init(frame: CGRect, backgroundColor: UIColor, sourceData: [(String, Double)]) {
        self.init(frame: frame)
        self.backgroundColor = backgroundColor
        combinedDiagram = lineGraph(sourceData: sourceData, rect: self.bounds)
    }
    
    override func draw(_ rect: CGRect) {
        guard let diagram = combinedDiagram else {return}
        let context = UIGraphicsGetCurrentContext()
        context?.draw(diagram.0, in: rect)
        context?.draw(points: diagram.1)
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
