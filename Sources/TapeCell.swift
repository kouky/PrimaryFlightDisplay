//
//  TapeCell.swift
//  PrimaryFlightDisplay
//
//  Created by Michael Koukoullis on 23/01/2016.
//  Copyright © 2016 Michael Koukoullis. All rights reserved.
//

import SpriteKit

class TapeCell: SKNode {
    
    var model: TapeCellModelType {
        didSet {
            removeAllChildren()
            createMarkerNodes()
        }
    }
    
    var positionForZeroValue: CGPoint {
        return positionForValue(value: 0)
    }
    
    private let style: TapeIndicatorStyleType
    
    init(model: TapeCellModelType, style: TapeIndicatorStyleType) {
        self.model = model
        self.style = style
        super.init()
        createMarkerNodes()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     private func positionForValue(value: Double) -> CGPoint {
        let valuePosition = (model.midValue - value) * Double(style.pointsPerUnitValue)
        switch style.markerJustification {
        case .top, .bottom:
            return CGPoint(x: CGFloat(valuePosition), y: position.y)
        case .left, .right:
            return CGPoint(x: position.x, y: CGFloat(valuePosition))
        }
    }
    
    private func createMarkerNodes() {
        Array(model.lowerValue..<model.upperValue)
            .compactMap({CellMarker(value: $0, style: style)})
            .forEach { marker in
                addChild(buildLineNode(marker: marker))
                
                if marker.isMajor {
                    addChild(buildLabelNode(marker: marker))
                }
            }
    }
    
    private func buildLineNode(marker: CellMarker) -> SKShapeNode {
        let line =  SKShapeNode(rectOf: marker.lineSize)
        line.strokeColor = style.markerColor
        line.fillColor = style.markerColor
        
        switch style.markerJustification {
        case .top:
            line.position = CGPoint(
                x: CGFloat(((marker.value - model.lowerValue) * Int(style.pointsPerUnitValue))) - (CGFloat(model.magnitude) * CGFloat(style.pointsPerUnitValue))/2,
                y: (style.size.height - CGFloat(marker.lineSize.height))/2)
        case .bottom:
            line.position = CGPoint(
                x: CGFloat(((marker.value - model.lowerValue) * Int(style.pointsPerUnitValue))) - (CGFloat(model.magnitude) * CGFloat(style.pointsPerUnitValue))/2,
                y: (CGFloat(marker.lineSize.height) - style.size.height)/2)
        case .left:
            line.position = CGPoint(
                x: (CGFloat(marker.lineSize.width) - style.size.width)/2,
                y: CGFloat(((marker.value - model.lowerValue) * Int(style.pointsPerUnitValue))) - (CGFloat(model.magnitude) * CGFloat(style.pointsPerUnitValue))/2)
        case .right:
            line.position = CGPoint(
                x: (style.size.width - CGFloat(marker.lineSize.width))/2,
                y: CGFloat(((marker.value - model.lowerValue) * Int(style.pointsPerUnitValue))) - (CGFloat(model.magnitude) * CGFloat(style.pointsPerUnitValue))/2)
        }
        
        return line
    }
    
    private func buildLabelNode(marker: CellMarker) -> SKLabelNode {
        let label = SKLabelNode(text: style.labelForValue(value: marker.value))
        label.fontName = style.font.family
        label.fontSize = style.font.size
        label.horizontalAlignmentMode = marker.labelAlignment.horizontal
        label.verticalAlignmentMode = marker.labelAlignment.vertical
        label.color = style.markerTextColor
        
        switch style.markerJustification {
        case .top:
            label.position = CGPoint(
                x: CGFloat(((marker.value - model.lowerValue) * Int(style.pointsPerUnitValue))) - (CGFloat(model.magnitude) * CGFloat(style.pointsPerUnitValue))/2,
                y: style.size.height/2 - CGFloat(style.markerTextOffset))
        case .bottom:
            label.position = CGPoint(
                x: CGFloat(((marker.value - model.lowerValue) * Int(style.pointsPerUnitValue))) - (CGFloat(model.magnitude) * CGFloat(style.pointsPerUnitValue))/2,
                y: CGFloat(style.markerTextOffset) - style.size.height/2)
        case .left:
            label.position = CGPoint(
                x: CGFloat(style.markerTextOffset) - style.size.width/2,
                y: CGFloat(((marker.value - model.lowerValue) * Int(style.pointsPerUnitValue))) - (CGFloat(model.magnitude) * CGFloat(style.pointsPerUnitValue))/2)
        case .right:
            label.position = CGPoint(
                x: style.size.width/2 - CGFloat(style.markerTextOffset),
                y: CGFloat(((marker.value - model.lowerValue) * Int(style.pointsPerUnitValue))) - (CGFloat(model.magnitude) * CGFloat(style.pointsPerUnitValue))/2)
        }

        return label
    }
}

private struct CellMarker {
    let value: Int
    let lineSize: CGSize
    let isMajor: Bool
    let labelAlignment: (horizontal: SKLabelHorizontalAlignmentMode, vertical: SKLabelVerticalAlignmentMode)

    init?(value: Int, style: TapeIndicatorStyleType) {
        let isMajor = value % style.majorMarkerFrequency == 0
        let isMinor = value % style.minorMarkerFrequency == 0
        
        guard isMajor || isMinor else { return nil }
        
        self.value = value
        self.isMajor = isMajor
        
        let length = isMajor ? style.majorMarkerLength : style.minorMarkerLength
        switch style.markerJustification {
        case .top, .bottom: lineSize = CGSize(width: 0, height: length)
        case .left, .right: lineSize = CGSize(width: length, height: 0)
        }
        
        switch style.markerJustification {
        case .top: labelAlignment = (horizontal: .center, vertical: .top)
        case .bottom: labelAlignment = (horizontal: .center, vertical: .bottom)
        case .left: labelAlignment = (horizontal: .left, vertical: .center)
        case .right: labelAlignment = (horizontal: .right, vertical: .center)
        }
    }
}
