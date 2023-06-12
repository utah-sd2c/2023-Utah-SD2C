//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziFHIR
/// The context attached to each task in the CS342 2023 Utah Team Application.
public enum UtahTaskContext: Codable, Identifiable {
    case questionnaire(Questionnaire)
    case researchKitTask(ResearchKitTaskContext)
    
    
    public var id: String {
        switch self {
        case let .questionnaire(questionnaire):
            return questionnaire.id.description
        case let .researchKitTask(researchKitTaskContext):
            return researchKitTaskContext.rawValue
        }
    }
    
    var actionType: String {
        switch self {
        case .questionnaire:
            return String(localized: "QUESTIONNAIRE_ACTION", bundle: .module)
        case .researchKitTask:
            return String(localized: "RESEARCHKIT_TASK_ACTION", bundle: .module)
        }
    }
}
