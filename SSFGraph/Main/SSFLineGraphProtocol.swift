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
    func lineGraph(sourceData: [(String, Double)]) -> Diagram
}

extension SSFLineGraphProtocol {
    func lineGraph(sourceData: [(String, Double)]) -> Diagram {
        let values = sourceData.map {CGFloat($0.1)}.normalized.reduce([]) { (result: [(CGFloat, CGFloat)], value) in
            var line: (CGFloat, CGFloat)
            var temporaryResult = result
            if result.count == 0 {
                line = (0.0, value)
            } else {
                line = (result.last!.1, value)
            }
            temporaryResult.append(line)
            return temporaryResult
        }.dropFirst()
        
        var lines: [Diagram] = []
        for (index, value) in Array(values).enumerated() {
            let sPoint = CGPoint(x: CGFloat(0.5+Double(index)), y: 3 * value.0)
            let ePoint = CGPoint(x: CGFloat(1.5+Double(index)), y: 3 * value.1)
            lines.append(Diagram.straightLine(startPoint: sPoint, endPoint: ePoint).filled(UIColor.blue))
        }
        let alllines = lines.hcat
        
        let labels = sourceData.map { (string, _) in
            return Diagram.text(theText: string, width: 1, height: 0.3).aligned(to: CGPoint.top)
            }.hcat
        
        return alllines---labels
    }
}
