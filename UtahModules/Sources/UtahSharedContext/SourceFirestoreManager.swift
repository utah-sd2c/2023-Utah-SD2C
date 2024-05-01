//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable identifier_name
// swiftlint:disable type_contents_order
// swiftlint:disable legacy_objc_type
// swiftlint:disable force_unwrapping
// swiftlint:disable large_tuple
// swiftlint:disable closure_body_length
// swiftlint:disable function_body_length

import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import SpeziAccount
import SwiftUI

public class FirestoreManager: ObservableObject {
    private var db = Firestore.firestore()
    let user = Auth.auth().currentUser
    @Published public var disease: String = ""
    @Published public var observations: [(date: Date, value: Double)] = []
    @Published public var surveys = [:] as [String: [(dateCompleted: Date, score: Int, surveyId: String)]]
    // @Published public var surveys: [QuestionnaireResponse] = []
    
    var refresh = false

    public func update() {
       refresh.toggle()
    }
    
    public func fetchAll() {
        fetchData()
        _Concurrency.Task {
            await loadSurveys()
            await loadObservations(metricCode: "55423-8")
        }
    }
    
    public func fetchData() {
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users").document(user.uid).getDocument {document, err in
                if let err = err {
                    print("Error loading document: \(err)")
                    return
                }
                if let document = document, document.exists {
                    let data = document.data()
                    if let data = data {
                        self.disease = data["disease"] as? String ?? ""
                        let defaults = UserDefaults.standard
                        defaults.set(self.disease, forKey: "disease")
                    }
                }
            }
       }
    }
    
    public func loadSurveys() async {
        await withCheckedContinuation { continuation in
            if let user = Auth.auth().currentUser {
                Firestore.firestore().collection("users/\(user.uid)/QuestionnaireResponse").getDocuments { documents, err in
                    if err != nil {
                        return
                    } else {
                        self.surveys = [:]
                        for document in documents!.documents {
                            let data = document.data() as [String: Any]
                            // print(data)
                            guard let score = data["score"] as? Int else {
                                print("ERROR: score values nil")
                                continue
                            }
                            guard let surveyId = data["surveyId"] as? String else {
                                print("ERROR: surveyId values nil")
                                continue
                            }
                            guard let type = data["type"] as? String else {
                                print("ERROR: type values nil")
                                continue
                            }
                            guard let dateCompletedObject = data["dateCompleted"] as? Timestamp else {
                                print("ERROR: dateCompleted values nil")
                                continue
                            }
                            let dateCompleted = dateCompletedObject.dateValue()
                            if self.surveys[type] == nil {
                                self.surveys[type] = []
                            }
                            self.surveys[type]?.append((dateCompleted, score, surveyId))
                        }
                        continuation.resume()
                    }
                }
            }
        }
    }
    
//    func querySurveys(type: String, surveyId: String) async {
//        await withCheckedContinuation { continuation in
//            FirebaseApp.configure()
//            let db = Firestore.firestore()
//
//            var surveyName = "veinesssurveys"
//            if type == "edmonton" {
//                surveyName = "edmontonsurveys"
//            } else if type == "wiq" {
//                surveyName = "wiqsurveys"
//            }
//            let docRef = db.collection(surveyName).document(surveyId)
//            docRef.getDocument(as: QuestionnaireResponse.self) { result in
//                switch result {
//                case .success(let response):
//                    print(response)
//                    //self.surveys.append(response)
//                case .failure(let error):
//                    print(error)
//                }
//            }
//        }
//    }
        
    public func loadObservations(metricCode: String) async {
        await withCheckedContinuation { continuation in
            var observations = [] as [(date: Date, value: Double)]
            if let user = Auth.auth().currentUser {
                Firestore.firestore().collection("users/\(user.uid)/Observation").getDocuments {snapshot, err in
                    if err != nil || snapshot == nil || snapshot?.isEmpty == true {
                        return
                    } else {
                        for document in snapshot!.documents {
                            // pulls data from firestore and tries to match code correct metric
                            let data = document.data() as [String: Any]
                            guard let codeObject = data["code"] as? [String: Any] else {
                                print("ERROR: code object values nil")
                                continue
                            }
                            guard let coding = codeObject["coding"] as? [Any] else {
                                print("ERROR: coding object values nil")
                                continue
                            }
                            guard let code = coding[0] as? [String: Any] else {
                                print("ERROR: code values nil")
                                continue
                            }
                            guard let filterCode = code["code"] as? String else {
                                print("ERROR: filterCode values nil")
                                continue
                            }
                            
                            if filterCode == metricCode {
                                // properly formats date
                                guard let issuedDate = data["issued"] as? String else {
                                    print("ERROR: issuedDate values nil")
                                    continue
                                }
                                let array = issuedDate.components(separatedBy: ".")
                                let shortenedDate = array[0] + array[1].suffix(6)

                                let formatter = DateFormatter()
                                formatter.timeZone = NSTimeZone.local
                                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                                let date = formatter.date(from: shortenedDate)
                                
                                let valueQuantity = data["valueQuantity"] as? [String: Any]
                                let value = valueQuantity?["value"] as? Double ?? 0.0
                                observations.append((date: date!, value: value))
                            }
                        }
                        self.observations = observations
                    }
                    continuation.resume()
                }
            } else {
                continuation.resume()
            }
        }
    
        /*_Concurrency.Task { @MainActor in
            
            self.observations = observations.filter { observation in
                observation.code.coding?.contains(where: { coding in coding.code?.value?.string == code }) ?? false
            }
        }*/
    }
    
    public init() {
        fetchData()
        _Concurrency.Task {
            await loadSurveys()
            await loadObservations(metricCode: "55423-8")
        }
    }
}
