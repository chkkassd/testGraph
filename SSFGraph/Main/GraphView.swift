//
//  GraphView.swift
//  SSFGraph
//
//  Created by 赛峰 施 on 2018/5/16.
//  Copyright © 2018年 赛峰 施. All rights reserved.
//

import UIKit

class GraphView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var combinedDiagram: Diagram = Diagram()
    
    convenience init(frame: CGRect, backgroundColor: UIColor, sourceData: [(String, Double)]) {
        self.init(frame: frame)
        self.backgroundColor = backgroundColor
        combinedDiagram = barGraph(sourceData: sourceData)
    }
    
    func barGraph(sourceData: [(String, Double)]) -> Diagram {
        let values = sourceData.map {CGFloat($0.1)}
        let bars = values.normalized.map { x in
            return Diagram.rect(width: 1, height: 3 * x).filled(UIColor.black).aligned(to: CGPoint.bottom)
        }.hcat
        let labels = sourceData.map { (string, _) in
            return Diagram.text(theText: string, width: 1, height: 0.3).aligned(to: CGPoint.top)
        }.hcat
        return bars---labels
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.draw(combinedDiagram, in: rect)
    }
}
