//
//  Model.swift
//  PrimaryFlightDisplay
//
//  Created by Michael Koukoullis on 7/01/2016.
//  Copyright © 2016 Michael Koukoullis. All rights reserved.
//

import SpriteKit

protocol AttitudeType {
    var rollRadians: Double { get }
    var pitchRadians: Double { get }
    
    func rollAction() -> SKAction
    func pitchAction(sceneSize: CGSize) -> SKAction
    func pitchReverseAction(sceneSize: CGSize) -> SKAction
}

protocol AttitudeSettable {
    func setAttitude(_ attitude: AttitudeType)
}

extension AttitudeType {
    func rollAction() -> SKAction {
        return SKAction.rotate(toAngle: CGFloat(rollRadians), duration: 0.05, shortestUnitArc: true)
    }
    
    func pitchAction(sceneSize: CGSize) -> SKAction {
        let displacement = CGFloat(pitchRadians) * -1 * sceneSize.pointsPerRadian
        return SKAction.moveTo(y: displacement, duration: 0.05)
    }
    
    func pitchReverseAction(sceneSize: CGSize) -> SKAction {
        let displacement = CGFloat(pitchRadians) * sceneSize.pointsPerRadian
        return SKAction.moveTo(y: displacement, duration: 0.05)
    }
}

struct Attitude: AttitudeType {
    let pitchRadians: Double
    let rollRadians: Double
}
