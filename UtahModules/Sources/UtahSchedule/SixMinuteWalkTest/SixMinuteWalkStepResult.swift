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
    public var score: Int?
    
    enum Keys: String {
        case score
    }
    
    override public init(identifier: String) {
        super.init(identifier: identifier)
    }
    
    override public func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(score, forKey: Keys.score.rawValue)
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        score = aDecoder.decodeObject(forKey: Keys.score.rawValue) as? Int
    }
    
    public class func supportsSecureCoding() -> Bool {
        true
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        let isParentSame = super.isEqual(object)
        
        if let castObject = object as? SixMinuteWalkStepResult {
            return (isParentSame &&
                    (score == castObject.score))
        }
        return true
    }
    
    override public func copy(with zone: NSZone? = nil) -> Any {
        if let result = super.copy(with: zone) as? SixMinuteWalkStepResult {
            result.score = score
            return result
        } else {
            return super.copy(with: zone)
        }
    }
}
