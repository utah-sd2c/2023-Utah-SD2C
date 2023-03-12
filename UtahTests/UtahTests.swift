//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import ResearchKit
@testable import Utah
import UtahSchedule
import XCTest


class UtahTests: XCTestCase {
    func testExample() throws {
        XCTAssertTrue(true)
    }

    func testEdmontonUtil() throws {
        var steps = [ORKStep]()
        QuestionnaireUtil.addEdmontonSteps(steps: &steps)
        XCTAssertFalse(steps.isEmpty)
    }
    
    func testWIQUtil() throws {
        var steps = [ORKStep]()
        QuestionnaireUtil.addWIQSteps(steps: &steps)
        XCTAssertFalse(steps.isEmpty)
    }
    
    func testVEINESUtil() throws {
        var steps = [ORKStep]()
        QuestionnaireUtil.addVEINESSteps(steps: &steps)
        XCTAssertFalse(steps.isEmpty)
    }
}
