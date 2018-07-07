//
//  TapeIndicator.swift
//  PrimaryFlightDisplay
//
//  Created by Michael Koukoullis on 18/01/2016.
//  Copyright © 2016 Michael Koukoullis. All rights reserved.
//

import SpriteKit


class TapeIndicator: SKNode {
    
    let style: TapeIndicatorStyleType
    let pointer: TapePointer
    let cellContainer: TapeCellContainer
    let cropNode = SKCropNode()
    
    var value: Double = 0 {
        didSet {
            cellContainer.run(cellContainer.actionForValue(value: value))
            pointer.value = Int(value)
        }
    }
    
    init(style: TapeIndicatorStyleType) {
        switch style.markerJustification {
        case .Bottom, .Top:
            if style.type == .Compass && (style.size.width / CGFloat(style.pointsPerUnitValue) > CGFloat(style.optimalCellMagnitude)) {
                fatalError("Invalid Compass style: Decrease width and / or increase pointsPerUnitValue")
            }
        case .Left, .Right:
            if style.type == .Compass && (style.size.height / CGFloat(style.pointsPerUnitValue) > CGFloat(style.optimalCellMagnitude)) {
                fatalError("Invalid Compass style: Decrease height and / or increase pointsPerUnitValue")
            }
        }
        
        self.style = style
        let seedModel = style.seedModel
        do {
            cellContainer = try TapeCellContainer(seedModel: seedModel, style: style)
        } catch  {
            fatalError("Seed model lower value must be zero")
        }
        pointer = TapePointer(initialValue: style.seedModel.lowerValue, style: style)
        super.init()

        let backgroundShape = SKShapeNode(rectOf: style.size, cornerRadius: 2)
        backgroundShape.fillColor = style.backgroundColor
        backgroundShape.strokeColor = SKColor.clear

        backgroundShape.zPosition = 0
        cellContainer.zPosition = 1
        pointer.zPosition = 2
        
        cropNode.addChild(backgroundShape)
        cropNode.addChild(cellContainer)
        cropNode.addChild(pointer)
        cropNode.maskNode = SKSpriteNode(color: SKColor.black, size: style.size)
        addChild(cropNode)
    }
    
    func recycleCells() {
        cellContainer.recycleCells()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
