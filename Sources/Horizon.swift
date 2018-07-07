//
//  Horizon.swift
//  PrimaryFlightDisplay
//
//  Created by Michael Koukoullis on 21/11/2015.
//  Copyright © 2015 Michael Koukoullis. All rights reserved.
//

import SpriteKit

class Horizon: SKNode {
    
    let sceneSize: CGSize

    private let gimbalNode = SKNode()
    private let skyNode: SKSpriteNode
    private let groundNode: SKSpriteNode
    private let zeroPitchLine: SKShapeNode
    
    init(sceneSize: CGSize, style: HorizonStyleType) {
        self.sceneSize = sceneSize
        skyNode = SKSpriteNode(color: style.skyColor, size: CGSize(width: 100, height: 100))
        groundNode = SKSpriteNode(color: style.groundColor, size: CGSize(width: 100, height: 100))
        zeroPitchLine = SKShapeNode(rectOf: CGSize(width: 2 * sceneSize.width, height: 1))
        super.init()
        
        skyNode.size = CGSize(width: sceneSize.width * 2, height: sceneSize.height * 2)
        groundNode.size = CGSize(width: sceneSize.width * 2, height: sceneSize.height * 2)
        skyNode.position = CGPoint(x: 0, y: sceneSize.height)
        groundNode.position = CGPoint(x: 0, y: -sceneSize.height)
        zeroPitchLine.strokeColor = style.zeroPitchLineColor
        zeroPitchLine.position = CGPoint.zero
        
        gimbalNode.addChild(skyNode)
        gimbalNode.addChild(groundNode)
        gimbalNode.addChild(zeroPitchLine)
        addChild(gimbalNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Horizon: AttitudeSettable {
    
    func setAttitude(attitude: AttitudeType) {
        gimbalNode.run(attitude.pitchAction(sceneSize: sceneSize))
        run(attitude.rollAction())
    }
}

