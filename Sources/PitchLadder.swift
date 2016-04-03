//
//  PitchLadder.swift
//  PrimaryFlightDisplay
//
//  Created by Michael Koukoullis on 5/01/2016.
//  Copyright © 2016 Michael Koukoullis. All rights reserved.
//

import SpriteKit

class PitchLadder: SKNode {
    
    let sceneSize: CGSize
    private let cropNode = SKCropNode()
    private let maskNode: SKSpriteNode
    
    init(sceneSize: CGSize, style: PitchLadderStyleType) {
        self.sceneSize = sceneSize
        let maskSize = CGSize(
            width:  CGFloat(style.majorLineWidth) * 3.0,
            height: sceneSize.pointsPerDegree * (CGFloat(style.magnitudeDisplayDegree) + 4))
        self.maskNode = SKSpriteNode(color: SKColor.blackColor(), size: maskSize)
        super.init()
        
        let builder = PitchLineBuilder(style: style)
        let degreeValues = Array(5.stride(to: 91, by: 5))
        
        let skyPitchLines = degreeValues.map { degree in
            return (degree, (degree % 10 == 0) ? PitchLineType.Major : PitchLineType.Minor)
        }
        let pitchLines = skyPitchLines + skyPitchLines.map { ($0.0 * -1, $0.1) }
        for (degree, type) in pitchLines {
            cropNode.addChild(builder.pitchLine(sceneSize: sceneSize, degree: degree, type: type))
        }
        for (degree, type) in pitchLines.filter({ $1 == .Major }) {
            cropNode.addChild(builder.leftPitchLineLabel(sceneSize: sceneSize, degree: degree, type: type))
            cropNode.addChild(builder.rightPitchLineLabel(sceneSize: sceneSize, degree: degree, type: type))
        }
        
        cropNode.maskNode = maskNode
        addChild(cropNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PitchLadder: AttitudeSettable {
    
    func setAttitude(attitude: AttitudeType) {
        cropNode.runAction(attitude.pitchAction(sceneSize: sceneSize))
        maskNode.runAction(attitude.pitchReverseAction(sceneSize: sceneSize))
        runAction(attitude.rollAction())
    }
}

private enum PitchLineType {
    case Major
    case Minor
}

private struct PitchLineBuilder {
    
    let style: PitchLadderStyleType
    
    func pitchLine(sceneSize sceneSize: CGSize, degree: Int, type: PitchLineType) -> SKShapeNode {
        
        let halfWidth = halfWidthForPitchLineType(type)
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, -halfWidth, 2)
        CGPathAddLineToPoint(path, nil, halfWidth, 2)
        CGPathAddLineToPoint(path, nil, halfWidth, -2)
        CGPathAddLineToPoint(path, nil, -halfWidth, -2)
        CGPathCloseSubpath(path)
        
        var transform = CGAffineTransformMakeTranslation(0, CGFloat(degree) * sceneSize.pointsPerDegree)
        let transformedPath = withUnsafeMutablePointer(&transform) {
            CGPathCreateMutableCopyByTransformingPath(path, $0)
        }

        let line = SKShapeNode(path: transformedPath!)
        line.fillColor = style.fillColor
        line.strokeColor = style.strokeColor
        return line
    }
    
    func leftPitchLineLabel(sceneSize sceneSize: CGSize, degree: Int, type: PitchLineType) -> SKLabelNode {
        let label = pitchLineLabel(sceneSize: sceneSize, degree: degree, type: type)
        label.horizontalAlignmentMode = .Right
        label.position.x = -halfWidthForPitchLineType(type) - CGFloat(style.markerTextOffset)
        return label
    }

    func rightPitchLineLabel(sceneSize sceneSize: CGSize, degree: Int, type: PitchLineType) -> SKLabelNode {
        let label = pitchLineLabel(sceneSize: sceneSize, degree: degree, type: type)
        label.horizontalAlignmentMode = .Left
        label.position.x = halfWidthForPitchLineType(type) + CGFloat(style.markerTextOffset)
        return label
    }

    private func pitchLineLabel(sceneSize sceneSize: CGSize, degree: Int, type: PitchLineType) -> SKLabelNode {
        let label = SKLabelNode(text: "\(degree)")
        label.fontName = style.font.family
        label.fontSize = style.font.size
        label.fontColor = style.textColor
        label.verticalAlignmentMode = .Center
        label.position.y = CGFloat(degree) * sceneSize.pointsPerDegree
        return label
    }
    
    private func widthForPitchLineType(type: PitchLineType) -> CGFloat {
        switch type {
        case .Major: return CGFloat(style.majorLineWidth)
        case .Minor: return CGFloat(style.minorLineWidth)
        }
    }
    
    private func halfWidthForPitchLineType(type: PitchLineType) -> CGFloat {
        return widthForPitchLineType(type) / 2
    }
}
