//
//  AttitudeReferenceIndex.swift
//  PrimaryFlightDisplay
//
//  Created by Michael Koukoullis on 4/01/2016.
//  Copyright © 2016 Michael Koukoullis. All rights reserved.
//

import SpriteKit

class AttitudeReferenceIndex: SKNode {
    
    let style: AttitudeReferenceIndexStyleType
    
    init(style: AttitudeReferenceIndexStyleType) {
        self.style = style
        super.init()
        
        addChild(buildLeftBar(transform: CGAffineTransform(translationX: CGFloat(-style.sideBarOffset), y: 0)))
        addChild(buildLeftBar(transform: CGAffineTransform(a: -1, b: 0, c: 0, d: 1, tx: CGFloat(style.sideBarOffset), ty: 0)))
        addChild(buildCenterBar())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildLeftBar(transform: CGAffineTransform) -> SKShapeNode {
        let width = CGFloat(style.sideBarWidth)
        let height = CGFloat(style.sideBarHeight)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: -width, y: halfLineThickness))
        path.addLine(to: CGPoint(x: 0, y: halfLineThickness))
        path.addLine(to: CGPoint(x: 0, y: -height))
        path.addLine(to: CGPoint(x: -style.lineThickness, y: -height))
        path.addLine(to: CGPoint(x: -style.lineThickness, y: -halfLineThickness))
        path.addLine(to: CGPoint(x: -width, y: -halfLineThickness))
        path.closeSubpath()

        var trans = transform
        let transformedPath = withUnsafeMutablePointer(to: &trans) {
            path.mutableCopy(using: $0)
        }
        
        let shape = SKShapeNode(path: transformedPath!)
        shape.fillColor = style.fillColor
        shape.strokeColor = style.strokeColor
        return shape
    }
    
    private func buildCenterBar() -> SKShapeNode {
        let halfWidth = CGFloat(style.centerBarWidth) / 2
        let path = CGMutablePath()
        path.move(to: CGPoint(x: -halfWidth, y: halfLineThickness))
        path.addLine(to: CGPoint(x: halfWidth, y: halfLineThickness))
        path.addLine(to: CGPoint(x: halfWidth, y: -halfLineThickness))
        path.addLine(to: CGPoint(x: -halfWidth, y: -halfLineThickness))
        path.closeSubpath()
        
        let shape = SKShapeNode(path: path)
        shape.fillColor = style.fillColor
        shape.strokeColor = style.strokeColor
        return shape
    }
    
    private var halfLineThickness: CGFloat {
        return style.lineThickness * 0.5
    }
}
