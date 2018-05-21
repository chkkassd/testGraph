//
//  SSFBarGraphProtocol.swift
//  SSFGraph
//
//  Created by 赛峰 施 on 2018/5/18.
//  Copyright © 2018年 赛峰 施. All rights reserved.
//

import Foundation
import UIKit

protocol SSFBarGraphProtocol {
    func barGraph(sourceData: [(String, Double)]) -> Diagram
}

extension SSFBarGraphProtocol {
    
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
}
