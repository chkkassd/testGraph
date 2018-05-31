//
//  SSFLineGraphProtocol.swift
//  SSFGraph
//
//  Created by 赛峰 施 on 2018/5/22.
//  Copyright © 2018年 赛峰 施. All rights reserved.
//

import Foundation
import UIKit

protocol SSFLineGraphProtocol {
    func lineGraph(sourceData: [(String, Double)], rect: CGRect) -> (Diagram, [CGPoint])
}

extension SSFLineGraphProtocol {
    func lineGraph(sourceData: [(String, Double)], rect: CGRect) -> (Diagram, [CGPoint]) {
        let values = sourceData.map {CGFloat($0.1)}
        let bars = values.normalized.map { x in
            return Diagram.rect(width: 1, height: 3 * x).filled(UIColor.blue).aligned(to: CGPoint.bottom)
            }.hcat
        let labels = sourceData.map { (string, _) in
            return Diagram.text(theText: string, width: 1, height: 0.3).aligned(to: CGPoint.top)
            }.hcat
        let combinedDiagram = bars---labels
        var points = [CGPoint]()
        combinedDiagram.pointsOfPrimitive(rect, direction: .topBorder, primitiveType: .rectangle, points: &points)
        return (combinedDiagram, points.reject{$0.x.isNaN || $0.y.isNaN})
    }
}
