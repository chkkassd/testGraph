//
//  SSFGraph.swift
//  SSFGraph
//
//  Created by 赛峰 施 on 2018/5/9.
//  Copyright © 2018年 赛峰 施. All rights reserved.
//The most important point is that we firstly forcous on how to describe a graph, and then we draw it.

import Foundation
import UIKit
import CoreGraphics

//The primitive of a graph,such as rectangle,text and so on.
enum Primitive {
    case ellipse
    case rectangle
    case text(String)
}

//The attribute of a diagram
enum Attribute {
    case fillcolor(UIColor)
}

//Use this enum to describe graph including size,poisition,attribute and so on.And we use recursion.
indirect enum Diagram {
    case primitive(CGSize, Primitive)
    case beside(Diagram, Diagram)
    case below(Diagram, Diagram)
    case attribute(Attribute, Diagram)
    case align(CGPoint, Diagram)
}

extension Diagram {
    var size: CGSize {
        switch self {
        case .primitive(let size, _):
            return size
        case .attribute(_, let d):
            return d.size
        case let .beside(l, r):
            return CGSize(width: l.size.width + r.size.width, height: max(l.size.height, r.size.height))
        case let .below(up, down):
            return CGSize(width: max(up.size.width, down.size.width), height: up.size.height + down.size.height)
        case .align(_, let d):
            return d.size
        }
    }
    
    init() {
        self = .primitive(CGSize(width: 0, height: 0), .rectangle)
    }
    
    //MARK: Combinator
    static func rect(width: CGFloat, height: CGFloat) -> Diagram {
        return .primitive(CGSize(width: width, height: height), .rectangle)
    }
    
    static func circle(diameter: CGFloat) -> Diagram {
        return .primitive(CGSize(width: diameter, height: diameter), .ellipse)
    }
    
    static func text(theText: String, width: CGFloat, height: CGFloat) -> Diagram {
        return .primitive(CGSize(width: width, height: height), .text(theText))
    }
    
    static func square(side: CGFloat) -> Diagram {
        return rect(width: side, height: side)
    }
    
    func filled(_ color: UIColor) -> Diagram {
        return .attribute(.fillcolor(color), self)
    }
    
    func aligned(to position: CGPoint) -> Diagram {
        return .align(position, self)
    }
}

extension CGSize {
    /**
     Fit a size to a rect,and make sure that the width height ratio stays the same,and then sacle it based on the incoming rectangle, and then adjust the position.
     - Parameters:
        - rect: The incoming rectangle,size is sacled based on it.
        - alignment: The position of scaled size.(x,y),0<=x<=1,0<=y<=1.x=0 represents align left,x=1 represents align right,y=0 represents align top,y=1 represents align bottom.
     - Returns: The rect which has been scaled and adjust accroding incoming rect and alignment.
     - Authors:
     PETER SHI
     - date: 2018.5.10
     */
    func fit(into rect: CGRect, alignment: CGPoint) -> CGRect {
        let scale = min(rect.width/self.width, rect.height/self.height)
        let targetSize = scale * self
        let spacerSize = alignment.size * (rect.size - targetSize)
        return CGRect(origin: rect.origin + spacerSize.point, size: targetSize)
    }

    var point: CGPoint {
        return CGPoint(x: self.width, y: self.height)
    }
}

extension CGPoint {
    static let top = CGPoint(x: 0.5, y: 0)
    static let bottom = CGPoint(x: 0.5, y: 1)
    static let center = CGPoint(x: 0.5, y: 0.5)
    static let left = CGPoint(x: 0, y: 0.5)
    static let right = CGPoint(x: 1, y: 0.5)
    
    var size: CGSize {
        return CGSize(width: self.x, height: self.y)
    }
}

func *(l: CGFloat, r: CGSize) -> CGSize {
    return CGSize(width: r.width * l, height: r.height * l)
}

func *(l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: r.width * l.width, height: r.height * l.width)
}

func -(l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width - r.width, height: l.height - r.height)
}

func +(l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(x: l.x + r.x, y: l.y + r.y)
}

extension CGContext {
    func draw(_ primitive: Primitive, in frame: CGRect) {
        switch primitive {
        case .rectangle:
            fill(frame)
        case .ellipse:
            fillEllipse(in: frame)
        case .text(let text):
            let font = UIFont.systemFont(ofSize: 12)
            let attributes = [NSAttributedStringKey.font: font]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            attributedText.draw(in: frame)
        }
    }
    
    func draw(_ diagram: Diagram, in bounds: CGRect) {
        switch diagram {
        case let .primitive(size, primitive):
            let bounds = size.fit(into: bounds, alignment: CGPoint(x: 0.5, y: 0.5))
            draw(primitive, in: bounds)
        case let .align(alignment, diagram):
            let bounds = diagram.size.fit(into: bounds, alignment: alignment)
            draw(diagram, in: bounds)
        case let .beside(left, right):
            let (lbounds, rbounds) = bounds.split(ratio: left.size.width/diagram.size.width, edge: .minXEdge)
            draw(left, in: lbounds)
            draw(right, in: rbounds)
        case let .below(up, down):
            let (upBounds, downBounds) = bounds.split(ratio: up.size.height/diagram.size.height, edge: .minYEdge)
            draw(up, in: upBounds)
            draw(down, in: downBounds)
        case let .attribute(.fillcolor(color), diagram):
            saveGState()
            color.set()
            draw(diagram, in: bounds)
            restoreGState()
        }
    }
}

extension CGRect {
    func split(ratio: CGFloat, edge: CGRectEdge) -> (CGRect, CGRect) {
        let length = edge.isHorizontal ? width : height
        return divided(atDistance:length * ratio, from:edge)
    }
}

extension CGRectEdge {
    var isHorizontal: Bool {
        return self == .maxXEdge || self == .minXEdge
    }
}

//MARK: Combinator
precedencegroup VerticalCombination {
    associativity: left
}

precedencegroup HorizontalCombination {
    higherThan: VerticalCombination
    associativity: left
}

infix operator ||| : HorizontalCombination

func |||(l: Diagram, r: Diagram) -> Diagram {
    return .beside(l, r)
}

infix operator --- : VerticalCombination

func ---(top: Diagram, bottom: Diagram) -> Diagram {
    return .below(top, bottom)
}
