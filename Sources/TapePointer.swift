//
//  TapePointer.swift
//  PrimaryFlightDisplay
//
//  Created by Michael Koukoullis on 23/02/2016.
//  Copyright © 2016 Michael Koukoullis. All rights reserved.
//

import SpriteKit
import Darwin

class TapePointer: SKNode {
    
    let style: TapeIndicatorStyleType
    private let valueLabel: SKLabelNode
    private let legendKeyLabelNode: SKLabelNode?
    private let legendValueLabelNode: SKLabelNode?
    
    var value: Int {
        didSet {
            valueLabel.text = style.labelForValue(value: value)
        }
    }
    
    init(initialValue: Int, style: TapeIndicatorStyleType) {
        self.value = initialValue
        self.style = style
        valueLabel = SKLabelNode(text: style.labelForValue(value: value))
        if let legend = style.legend {
            legendKeyLabelNode = SKLabelNode(text: legend.key)
            legendValueLabelNode = SKLabelNode(text: legend.value)
        } else {
            legendKeyLabelNode = nil
            legendValueLabelNode = nil
        }
        
        super.init()
        
        addChild(buildBackgroundShape())
        styleLabelNode()
        addChild(valueLabel)
        if let node = legendKeyLabelNode {
            addChild(node)
        }
        if let node = legendValueLabelNode {
            addChild(node)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func styleLabelNode() {
        valueLabel.fontName = style.font.family
        valueLabel.fontSize = style.font.size
        valueLabel.fontColor = style.markerTextColor

        legendKeyLabelNode?.fontName = style.font.family
        legendKeyLabelNode?.fontSize = round(style.font.size * CGFloat(0.5))
        legendKeyLabelNode?.fontColor = style.markerTextColor.withAlphaComponent(0.7)

        legendValueLabelNode?.fontName = style.font.family
        legendValueLabelNode?.fontSize = round(style.font.size * CGFloat(0.5))
        legendValueLabelNode?.fontColor = style.markerTextColor.withAlphaComponent(0.7)

        switch style.markerJustification {
        case .top:
            valueLabel.horizontalAlignmentMode = .center
            valueLabel.verticalAlignmentMode = .top
            valueLabel.position = CGPoint(x: 0, y: style.size.height/2 - CGFloat(style.markerTextOffset))
        case .bottom:
            valueLabel.horizontalAlignmentMode = .center
            valueLabel.verticalAlignmentMode = .bottom
            valueLabel.position = CGPoint(x: 0, y: CGFloat(style.markerTextOffset) - style.size.height/2)
        case .left:
            valueLabel.horizontalAlignmentMode = .left
            valueLabel.verticalAlignmentMode = .center
            valueLabel.position = CGPoint(
                x: CGFloat(style.markerTextOffset) - style.size.width/2,
                y: 0)
            
            legendKeyLabelNode?.horizontalAlignmentMode = .left
            legendKeyLabelNode?.verticalAlignmentMode = .top
            legendKeyLabelNode?.position = CGPoint(
                x: CGFloat(style.markerTextOffset) - style.size.width/2,
                y: backgroundShapeDimensions().thirdWidth)
            
            legendValueLabelNode?.horizontalAlignmentMode = .left
            legendValueLabelNode?.verticalAlignmentMode = .bottom
            legendValueLabelNode?.position = CGPoint(
                x: CGFloat(style.markerTextOffset) - style.size.width/2,
                y: -backgroundShapeDimensions().thirdWidth)
        case .right:
            valueLabel.horizontalAlignmentMode = .right
            valueLabel.verticalAlignmentMode = .center
            valueLabel.position = CGPoint(
                x: style.size.width/2 - CGFloat(style.markerTextOffset),
                y: 0)

            legendKeyLabelNode?.horizontalAlignmentMode = .right
            legendKeyLabelNode?.verticalAlignmentMode = .top
            legendKeyLabelNode?.position = CGPoint(
                x: style.size.width/2 - CGFloat(style.markerTextOffset),
                y: backgroundShapeDimensions().thirdWidth)
            
            legendValueLabelNode?.horizontalAlignmentMode = .right
            legendValueLabelNode?.verticalAlignmentMode = .bottom
            legendValueLabelNode?.position = CGPoint(
                x: style.size.width/2 - CGFloat(style.markerTextOffset),
                y: -backgroundShapeDimensions().thirdWidth)
        }
    }
    
    private func buildBackgroundShape() -> SKShapeNode {
        let dimensions = backgroundShapeDimensions()
        let path = CGMutablePath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: dimensions.thirdWidth, y: dimensions.thirdWidth))
        path.addLine(to: CGPoint(x: dimensions.width, y: dimensions.thirdWidth))
        path.addLine(to: CGPoint(x: dimensions.width, y: -dimensions.thirdWidth))
        path.addLine(to: CGPoint(x: dimensions.thirdWidth, y: -dimensions.thirdWidth))
        path.closeSubpath()
        
        let translateTransform, rotateTransform: CGAffineTransform

        switch style.markerJustification {
        case .top:
            translateTransform = CGAffineTransform(translationX: -dimensions.halfWidth, y: 0)
            rotateTransform = CGAffineTransform(rotationAngle: CGFloat.pi / -2)
        case .bottom:
            translateTransform = CGAffineTransform(translationX: -dimensions.halfWidth, y: 0)
            rotateTransform = CGAffineTransform(rotationAngle: CGFloat.pi / -2)
        case .left:
            translateTransform = CGAffineTransform(translationX: -dimensions.halfWidth, y: 0)
            rotateTransform = CGAffineTransform.identity
        case .right:
            translateTransform = CGAffineTransform(translationX: -dimensions.halfWidth, y: 0)
            rotateTransform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        
        var transform = translateTransform.concatenating(rotateTransform)
        let transformedPath = withUnsafeMutablePointer(to: &transform) {
            path.mutableCopy(using: $0)
        }
        
        let shape = SKShapeNode(path: transformedPath!)
        shape.fillColor = style.pointerBackgroundColor
        shape.strokeColor = SKColor.white
        return shape
    }
    
    private func backgroundShapeDimensions() -> (width: CGFloat, halfWidth: CGFloat, thirdWidth: CGFloat) {
        let width, halfWidth, thirdWidth: CGFloat
        
        switch style.markerJustification {
        case .top, .bottom:
            width = CGFloat(style.size.height)
            halfWidth = width / 2
            thirdWidth = width / 3
        case .left, .right:
            width = style.size.width
            halfWidth = width / 2
            thirdWidth = width / 3
        }

        return (width, halfWidth, thirdWidth)
    }
}
