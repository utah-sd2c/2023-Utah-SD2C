//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable type_contents_order
import Foundation
import ResearchKit
import SwiftUI
import UIKit

public class SixMinuteWalkStep: ORKActiveStep {
    enum Key: String {
        case distance
    }
    
    public var distance = 3
    private let minimumDist = 1
    private let maxDist = 100

    override public class func stepViewControllerClass() -> AnyClass {
        SixMinuteWalkStepViewController.self
    }
    
    public class func supportsSecureCoding() -> Bool {
        true
    }
    
    override public func validateParameters() {
        super.validateParameters()
        assert(distance >= minimumDist, "distance should be greater or equal to \(minimumDist)")
        assert(distance <= maxDist, "distance should be less than or equal to \(maxDist)")
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
        
        shouldVibrateOnStart = true
        shouldShowDefaultTimer = false
        shouldContinueOnFinish = true
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        distance = aDecoder.decodeInteger(forKey: Key.distance.rawValue)
    }
    
    override public func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(distance, forKey: Key.distance.rawValue)
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        if let object = object as? SixMinuteWalkStep {
            return distance == object.distance
        }
        return false
    }
}
