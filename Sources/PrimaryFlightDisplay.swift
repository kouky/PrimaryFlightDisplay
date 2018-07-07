//
//  PrimaryFlightDisplayScene.swift
//  PrimaryFlightDisplay
//
//  Created by Michael Koukoullis on 21/11/2015.
//  Copyright © 2015 Michael Koukoullis. All rights reserved.
//

import SpriteKit

public class PrimaryFlightDisplayView: SKView {
    
    public init(frame: CGRect, settings: SettingsType = DefaultSettings()) {
        super.init(frame: frame)
        commonInit(settings: settings)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(settings: DefaultSettings())
    }
    
    private func commonInit(settings: SettingsType) {
        let scene = PrimaryFlightDisplayScene(size: bounds.size, settings: settings)
        scene.scaleMode = .aspectFill
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        presentScene(scene)
        
        // Apply additional optimizations to improve rendering performance
        ignoresSiblingOrder = true        
    }
    
    public func setHeadingDegree(_ degree: Double) {
        if let scene = scene as? PrimaryFlightDisplayScene {
            scene.setHeadingDegree(degree)
        }
    }
    
    public func setAirSpeed(_ airSpeed: Double) {
        if let scene = scene as? PrimaryFlightDisplayScene {
            scene.setAirSpeed(airSpeed)
        }
    }

    public func setAltitude(_ altitude: Double) {
        if let scene = scene as? PrimaryFlightDisplayScene {
            scene.setAltitude(altitude)
        }
    }
    
    public func setAttitude(rollRadians: Double, pitchRadians: Double) {
        if let scene = scene as? PrimaryFlightDisplayScene {
            scene.setAttitude(Attitude(pitchRadians: pitchRadians, rollRadians: rollRadians))
        }
    }
}

class PrimaryFlightDisplayScene: SKScene {
    
    private let horizon: Horizon
    private let pitchLadder: PitchLadder
    private let attitudeReferenceIndex: AttitudeReferenceIndex
    private let bankIndicator: BankIndicator
    private let altimeter: TapeIndicator
    private let airSpeedIndicator: TapeIndicator
    private let headingIndicator: TapeIndicator
    
    init(size: CGSize, settings: SettingsType) {
        horizon = Horizon(sceneSize: size, style: settings.horizon)
        pitchLadder = PitchLadder(sceneSize: size, style: settings.pitchLadder)
        attitudeReferenceIndex = AttitudeReferenceIndex(style: settings.attitudeReferenceIndex)
        bankIndicator = BankIndicator(style: settings.bankIndicator)
        altimeter = TapeIndicator(style: settings.altimeter)
        airSpeedIndicator = TapeIndicator(style: settings.airSpeedIndicator)
        headingIndicator = TapeIndicator(style: settings.headingIndicator)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        scaleMode = .resizeFill
        addChild(horizon)
        addChild(pitchLadder)
        addChild(attitudeReferenceIndex)
        addChild(bankIndicator)
        addChild(altimeter)
        addChild(airSpeedIndicator)
        addChild(headingIndicator)
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        altimeter.position = CGPoint(x: size.width/2 - altimeter.style.size.width/2, y: 0)
        airSpeedIndicator.position = CGPoint(x: -size.width/2 + airSpeedIndicator.style.size.width/2, y: 0)
        headingIndicator.position = CGPoint(x: 0, y: size.height/2 - headingIndicator.style.size.height/2)
    }
    
    override func didEvaluateActions() {
        altimeter.recycleCells()
        airSpeedIndicator.recycleCells()
        headingIndicator.recycleCells()
    }
    
    func setHeadingDegree(_ degree: Double) {
        headingIndicator.value = degree
    }
    
    func setAltitude(_ altitude: Double) {
        altimeter.value = altitude
    }

    func setAirSpeed(_ airSpeed: Double) {
        airSpeedIndicator.value = airSpeed
    }
}

extension PrimaryFlightDisplayScene: AttitudeSettable {

    func setAttitude(_ attitude: AttitudeType) {
        horizon.setAttitude(attitude)
        pitchLadder.setAttitude(attitude)
        bankIndicator.setAttitude(attitude)
    }
}
