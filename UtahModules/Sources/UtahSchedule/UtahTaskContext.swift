//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import FHIR


/// The context attached to each task in the CS342 2023 Utah Team Application.
///
/// We currently only support `Questionnaire`s, more cases can be added in the future.
public enum UtahTaskContext: Codable, Identifiable {
    /// The task schould display a `Questionnaire`.
    case questionnaire(Questionnaire)
    
    
    public var id: Questionnaire.ID {
        switch self {
        case let .questionnaire(questionnaire):
            return questionnaire.id
        }
    }
    
    var actionType: String {
        switch self {
        case .questionnaire:
            return String(localized: "QUESTIONNAIRE_ACTION", bundle: .module)
        }
    }
}
