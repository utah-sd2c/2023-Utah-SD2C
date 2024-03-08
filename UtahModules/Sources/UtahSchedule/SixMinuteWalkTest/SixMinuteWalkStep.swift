//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// See ResearchKit/ResearchKit/Common/ORKOrderedTask+ORKPredefinedActiveTask.m starting at line 786 for reference

// swiftlint:disable type_contents_order
import Foundation
import ResearchKit
import SwiftUI
import UIKit

public class SixMinuteWalkStep: ORKActiveStep { // Or do we want ORKFitnessStep?
    enum Key: String {
        case duration
    }
    
    public var duration = TimeInterval(360)
    
    //public var distance = 3
    //private let minimumDist = 1
    //private let maxDist = 100

    override public class func stepViewControllerClass() -> AnyClass {
        SixMinuteWalkStepViewController.self
    }
    
    public class func supportsSecureCoding() -> Bool {
        true
    }
    
    override public func validateParameters() {
        super.validateParameters()
        assert(stepDuration == TimeInterval(360), "duration must be 6 minutes (360 seconds)")
        //assert(distance >= minimumDist, "distance should be greater or equal to \(minimumDist)")
        //assert(distance <= maxDist, "distance should be less than or equal to \(maxDist)")
    }

    override public func startsFinished() -> Bool {
        false
    }
    
    override public var allowsBackNavigation: Bool {
        true
    }
    
    override public func copy(with zone: NSZone? = nil) -> Any {
        let walkStep = super.copy(with: zone)
        return walkStep
    }
    
    override public init(identifier: String) {
        super.init(identifier: identifier)
        
        self.stepDuration = duration
        self.title = "Test in Progress"
        self.text = "Walk as far as you can for 6 minutes. If you need to rest for any reason, press the “Rest” button. Resume as soon as you feel able to safely continue."
        self.spokenInstruction = self.text
        //self.recorderConfigurations = [self makeRecorderConfigurationsWithOptions:options];
        self.shouldContinueOnFinish = true
        self.isOptional = false
        self.shouldStartTimerAutomatically = true
        self.shouldVibrateOnStart = true
        self.shouldVibrateOnFinish = true
        self.shouldPlaySoundOnStart = true
        self.shouldPlaySoundOnFinish = true
        self.shouldSpeakRemainingTimeAtHalfway = true
        self.shouldSpeakCountDown = true
        
        //shouldVibrateOnStart = true
        //shouldShowDefaultTimer = false
        //shouldContinueOnFinish = true
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        duration = aDecoder.decodeDouble(forKey: Key.duration.rawValue)
    }
    
    override public func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(duration, forKey: Key.duration.rawValue)
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        if let object = object as? SixMinuteWalkStep {
            return duration == object.duration
        }
        return false
    }
}
