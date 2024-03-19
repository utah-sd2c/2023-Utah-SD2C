//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
// swiftlint:disable type_contents_order

import ResearchKit.Private

public class SixMinuteWalkStepResult: ORKResult {
    public var steps: Int?
    public var distance: Int?
    public var relativeTime: TimeInterval?
    public var absoluteTime: Date?
    
    enum Keys: String {
        case steps
        case distance
        case relativeTime
        case absoluteTime
    }
    
    override public init(identifier: String) {
        super.init(identifier: identifier)
    }
    
    override public func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(steps, forKey: Keys.steps.rawValue)
        aCoder.encode(distance, forKey: Keys.distance.rawValue)
        aCoder.encode(relativeTime, forKey: Keys.relativeTime.rawValue)
        aCoder.encode(absoluteTime, forKey: Keys.absoluteTime.rawValue)
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        steps = aDecoder.decodeObject(forKey: Keys.steps.rawValue) as? Int
        distance = aDecoder.decodeObject(forKey: Keys.distance.rawValue) as? Int
        relativeTime = aDecoder.decodeObject(forKey: Keys.relativeTime.rawValue) as? TimeInterval
        absoluteTime = aDecoder.decodeObject(forKey: Keys.absoluteTime.rawValue) as? Date
    }
    
    public class func supportsSecureCoding() -> Bool {
        true
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        let isParentSame = super.isEqual(object)
        
        if let castObject = object as? SixMinuteWalkStepResult {
            return (isParentSame &&
                    (steps == castObject.steps) &&
                    (distance == castObject.distance) &&
                    (relativeTime == castObject.relativeTime) &&
                    (absoluteTime == castObject.absoluteTime)
            )
        }
        return true
    }
    
    override public func copy(with zone: NSZone? = nil) -> Any {
        if let result = super.copy(with: zone) as? SixMinuteWalkStepResult {
            result.steps = steps
            result.distance = distance
            result.relativeTime = relativeTime
            result.absoluteTime = absoluteTime
            return result
        } else {
            return super.copy(with: zone)
        }
    }
}
