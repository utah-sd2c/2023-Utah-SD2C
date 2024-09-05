////
//// This source file is part of the CS342 2023 Utah Team Application project
////
//// SPDX-FileCopyrightText: 2023 Stanford University
////
//// SPDX-License-Identifier: MIT
////

import SwiftUI
import HealthKit
import FirebaseFirestore
import FirebaseAuth

public struct DistanceData: Identifiable {
    public var id = UUID()
    public var date: String
    public var distance: Double

    public init(date: String, distance: Double) {
        self.date = date
        self.distance = distance
    }
}

public struct StepData: Identifiable {
    public var id = UUID()
    public var date: String
    public var steps: Int

    public init(date: String, steps: Int) {
        self.date = date
        self.steps = steps
    }
}

public class HealthKitManager: ObservableObject {
    @Published public var distanceData: [DistanceData] = []
    @Published public var stepData: [StepData] = []
    @Published public var averageDistance: Double = 0.0
    @Published public var averageSteps: Double = 0.0
    private var refreshTimer: Timer?
    static let shared = HealthKitManager()
    
    private let healthStore = HKHealthStore()
    private let queue = DispatchQueue(label: "healthdataqueue", attributes: .concurrent)
    
    public init() {
        Task {
            do {
                try await requestAuthorization()
                await fetchDistanceData()
                await fetchStepData()
               
            }
        }
    }

    
    public func requestAuthorizationIfNeeded() {
        Task {
            do {
                try await requestAuthorization()
            } catch {
               
            }
        }
    }

    public func requestAuthorization() async throws {
        let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let readDataTypes: Set<HKObjectType> = [distanceType, stepType]
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            healthStore.requestAuthorization(toShare: nil, read: readDataTypes) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if !success {
                    continuation.resume(throwing: HealthKitAuthorizationError.authorizationFailed)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
    // This function is for showing the bar plot on the app
    public func fetchDistanceData() async {
           guard HKHealthStore.isHealthDataAvailable() else {
               return
           }

           let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
           let now = Date()
           let startDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
           let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)

           let distanceQuery = HKStatisticsCollectionQuery(
               quantityType: distanceType,
               quantitySamplePredicate: predicate,
               options: .cumulativeSum,
               anchorDate: Calendar.current.startOfDay(for: now),
               intervalComponents: DateComponents(day: 1)
           )

           distanceQuery.initialResultsHandler = { [weak self] query, results, error in
               guard let self = self else { return }
               if let error = error {
                   print("Error fetching distance data: \(error)")
                   return
               }

               guard let results = results else {
                   return
               }

               var tempDistanceData: [DistanceData] = []
               var tempTotalDistance: Double = 0.0

               results.enumerateStatistics(from: startDate, to: now) { statistics, stop in
                   if let sum = statistics.sumQuantity() {
                       let distance = sum.doubleValue(for: HKUnit.mile())
                       let date = statistics.startDate
                       let dateString = self.dateFormatter(date: date)
                       
                       tempTotalDistance += distance
                       tempDistanceData.append(DistanceData(date: dateString, distance: distance))
                   } else {
                       let date = statistics.startDate
                       let dateString = self.dateFormatter(date: date)
                       tempDistanceData.append(DistanceData(date: dateString, distance: 0.0))
                   }
               }

               self.updateDistanceDataOnMainThread(newDistanceData: tempDistanceData, totalDistance: tempTotalDistance)
           }

           healthStore.execute(distanceQuery)
       }

       private func updateDistanceDataOnMainThread(newDistanceData: [DistanceData], totalDistance: Double) {
           DispatchQueue.main.async { [weak self] in
               guard let self = self else { return }
               self.distanceData = newDistanceData
               self.averageDistance = newDistanceData.isEmpty ? 0 : totalDistance / Double(newDistanceData.count)
           }
       }

    // This function is for showing the bar plot on the app
    public func fetchStepData() async {
            guard HKHealthStore.isHealthDataAvailable() else {
                return
            }

            let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
            let now = Date()
            let startDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)

            let stepQuery = HKStatisticsCollectionQuery(
                quantityType: stepType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum,
                anchorDate: Calendar.current.startOfDay(for: now),
                intervalComponents: DateComponents(day: 1)
            )

            stepQuery.initialResultsHandler = { [weak self] query, results, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching step data: \(error)")
                    return
                }

                guard let results = results else {
                    return
                }

                var tempStepData: [StepData] = []
                var tempTotalSteps: Int = 0

                results.enumerateStatistics(from: startDate, to: now) { statistics, stop in
                    if let sum = statistics.sumQuantity() {
                        let steps = sum.doubleValue(for: HKUnit.count())
                        let date = statistics.startDate
                        let dateString = self.dateFormatter(date: date)
                        
                        tempTotalSteps += Int(steps)
                        tempStepData.append(StepData(date: dateString, steps: Int(steps)))
                    } else {
                        let date = statistics.startDate
                        let dateString = self.dateFormatter(date: date)
                        tempStepData.append(StepData(date: dateString, steps: 0))
                    }
                }

                self.updateStepDataOnMainThread(newStepData: tempStepData, totalSteps: tempTotalSteps)
            }

            healthStore.execute(stepQuery)
        }

        private func updateStepDataOnMainThread(newStepData: [StepData], totalSteps: Int) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.stepData = newStepData
                self.averageSteps = newStepData.isEmpty ? 0 : Double(totalSteps) / Double(newStepData.count)
            }
        }
    private func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    enum HealthKitAuthorizationError: Error {
        case authorizationFailed
    }
    
    // This function is mainly for retrieving all the steps from the date user joined after checking if the new collection exist with some data, it only uploads steps based on datejoined if stepcount collection didn't exist
    public func fetchStepDatabutton(from startDate: Date, to endDate: Date, completion: @escaping ([StepData]) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion([])
            return
        }

        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        let stepQuery = HKStatisticsCollectionQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: Calendar.current.startOfDay(for: startDate),
            intervalComponents: DateComponents(day: 1)
        )

        stepQuery.initialResultsHandler = { query, results, error in
            if let error = error {
                print("Error fetching step data: \(error)")
                completion([])
                return
            }

            guard let results = results else {
                completion([])
                return
            }

            var fetchedStepData: [StepData] = []

            results.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                if let sum = statistics.sumQuantity() {
                    let steps = sum.doubleValue(for: HKUnit.count())
                    let date = statistics.startDate
                    let dateString = self.dateFormatter(date: date)
                    
                    fetchedStepData.append(StepData(date: dateString, steps: Int(steps)))
                } else {
                    let date = statistics.startDate
                    let dateString = self.dateFormatter(date: date)
                    fetchedStepData.append(StepData(date: dateString, steps: 0))
                }
            }

            completion(fetchedStepData)
        }

        healthStore.execute(stepQuery)
    }


    public func StepCountCollectionExistsAndUpload(completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }

        let db = Firestore.firestore()
        let userCollection = db.collection("users").document(user.uid)
        let stepCountCollection = userCollection.collection("stepCountData")

        userCollection.getDocument { (document, error) in
            if let error = error {
                print("Error fetching user data: \(error)")
                completion(false)
                return
            }

            guard let document = document, document.exists,
                  let dateJoinedTimestamp = document.get("dateJoined") as? Timestamp else {
                completion(false)
                return
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            let dateJoined = dateJoinedTimestamp.dateValue()
            let todayDateString = dateFormatter.string(from: Date())

            // Check if there's any data in stepCountData collection
            stepCountCollection.order(by: "date", descending: true).limit(to: 1).getDocuments { (querySnapshot, error) in
                if error != nil {
                    completion(false)
                    return
                }

                var lastUpdatedDate: Date

                if let querySnapshot = querySnapshot, !querySnapshot.isEmpty, let latestDocument = querySnapshot.documents.first {
                    let latestDateString = latestDocument.get("date") as? String ?? todayDateString
                    lastUpdatedDate = dateFormatter.date(from: latestDateString) ?? dateJoined
                } else {
                    // If no data, we use dateJoined
                    lastUpdatedDate = dateJoined
                }

                // Use fetchStepDatabutton to fetch steps data from last updated date to today
                self.fetchStepDatabutton(from: lastUpdatedDate, to: Date()) { stepData in
                    if stepData.isEmpty {
                        completion(false)
                        return
                    }

                    if lastUpdatedDate == dateFormatter.date(from: todayDateString) {
                        // If last updated date is today, update today's document
                        self.uploadStepCountData(stepData: stepData, date: todayDateString, completion: completion)
                    } else {
                        // If last updated date is not today, update previous days and then today's data
                        self.uploadStepCountData(stepData: stepData, date: dateFormatter.string(from: lastUpdatedDate)) { success in
                            if success {
                                self.uploadMissingDaysStepData(stepData: stepData, from: dateFormatter.string(from: lastUpdatedDate), to: todayDateString) { success in
                                    if success {
                                        self.uploadStepCountData(stepData: stepData, date: todayDateString, completion: completion)
                                    } else {
                                        completion(false)
                                    }
                                }
                            } else {
                                completion(false)
                            }
                        }
                    }
                }
            }
        }
    }


     private func uploadStepCountData(stepData: [StepData], date: String, completion: @escaping (Bool) -> Void) {
         guard let user = Auth.auth().currentUser else {
             completion(false)
             return
         }

         let db = Firestore.firestore()
         let userCollection = db.collection("users").document(user.uid)
         let stepCountCollection = userCollection.collection("stepCountData")

         let filteredStepData = stepData.filter { data in
             return data.date == date
         }

         let totalSteps = filteredStepData.reduce(0) { $0 + $1.steps }
         let lastUpdatedAt = Timestamp(date: Date())

         let docRef = stepCountCollection.document(date)

         // let's fetch the document to check if it exists
         docRef.getDocument { (document, error) in
             if let document = document, document.exists {
                 // If Document exists, it updates the steps from the time it was lastupdated
                 docRef.updateData([
                     "steps": totalSteps,
                     "lastUpdatedAt": lastUpdatedAt
                 ]) { error in
                     if let _ = error {
                         completion(false)
                     } else {
                         completion(true)
                     }
                 }
             } else {
                 // If the document does not exist, create it with today's date
                 let dataDict: [String: Any] = [
                     "date": date,
                     "steps": totalSteps,
                     "timestamp": lastUpdatedAt,
                     "lastUpdatedAt": lastUpdatedAt
                 ]

                 docRef.setData(dataDict) { error in
                     if let _ = error {
                         completion(false)
                     } else {
                         completion(true)
                     }
                 }
             }
         }
     }

    private func uploadMissingDaysStepData(stepData: [StepData], from startDateString: String, to endDateString: String, completion: @escaping (Bool) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let startDate = dateFormatter.date(from: startDateString),
              let endDate = dateFormatter.date(from: endDateString) else {
            completion(false)
            return
        }

        var currentDate = startDate
        let group = DispatchGroup()
        var allUploadsSuccess = true

        while currentDate <= endDate {
            let currentDateString = dateFormatter.string(from: currentDate)
            let currentStepData = stepData.filter { $0.date == currentDateString }

            let totalSteps = currentStepData.reduce(0) { $0 + $1.steps }
            let timestamp = Timestamp(date: Date())

            let dataDict: [String: Any] = [
                "date": currentDateString,
                "steps": totalSteps,
                "timestamp": timestamp,
                "lastUpdatedAt": timestamp
            ]

            let user = Auth.auth().currentUser!
            let db = Firestore.firestore()
            let userCollection = db.collection("users").document(user.uid)
            let stepCountCollection = userCollection.collection("stepCountData")
            let docRef = stepCountCollection.document(currentDateString)

            group.enter()

            // Check if the document exists before setting the data
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // If the document exists, update it with the new data
                    let existingSteps = document.get("steps") as? Int ?? 0
                    if totalSteps > existingSteps {
                        docRef.updateData([
                            "steps": totalSteps,
                            "lastUpdatedAt": timestamp
                        ]) { error in
                            if error != nil {
                                allUploadsSuccess = false
                            }
                            group.leave()
                        }
                    } else {
                        group.leave()
                    }
                } else {
                    // If the document does not exist, create it
                    docRef.setData(dataDict) { error in
                        if let error = error {
                            allUploadsSuccess = false
                            print("Error uploading step data for \(currentDateString): \(error)")
                        }
                        group.leave()
                    }
                }
            }

            // Move to the next day
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }

        group.notify(queue: .main) {
            completion(allUploadsSuccess)
        }
    }
    
 // This function is mainly for retrieving all the distance from the date user joined after checking if the new collection exist with some data, it only uploads steps based on datejoined if distancedata collection didn't exist
    public func fetchDistanceDatabutton(from startDate: Date, to endDate: Date, completion: @escaping ([DistanceData]) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion([])
            return
        }

        let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        let distanceQuery = HKStatisticsCollectionQuery(
            quantityType: distanceType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: Calendar.current.startOfDay(for: startDate),
            intervalComponents: DateComponents(day: 1)
        )

        distanceQuery.initialResultsHandler = { query, results, error in
            if let error = error {
                print("Error fetching distance data: \(error)")
                completion([])
                return
            }

            guard let results = results else {
                completion([])
                return
            }

            var fetchedDistanceData: [DistanceData] = []

            results.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                if let sum = statistics.sumQuantity() {
                    let distance = sum.doubleValue(for: HKUnit.mile())
                    let date = statistics.startDate
                    let dateString = self.dateFormatter(date: date)
                    
                    fetchedDistanceData.append(DistanceData(date: dateString, distance: distance))
                } else {
                    let date = statistics.startDate
                    let dateString = self.dateFormatter(date: date)
                    fetchedDistanceData.append(DistanceData(date: dateString, distance: 0.0))
                }
            }

            completion(fetchedDistanceData)
        }

        healthStore.execute(distanceQuery)
    }

    public func DistanceDataCollectionExistsAndUpload(completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }

        let db = Firestore.firestore()
        let userCollection = db.collection("users").document(user.uid)
        let distanceDataCollection = userCollection.collection("distanceData")

        userCollection.getDocument { (document, error) in
            if let error = error {
                print("Error fetching user data: \(error)")
                completion(false)
                return
            }

            guard let document = document, document.exists,
                  let dateJoinedTimestamp = document.get("dateJoined") as? Timestamp else {
                completion(false)
                return
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            let dateJoined = dateJoinedTimestamp.dateValue()
            let todayDateString = dateFormatter.string(from: Date())

            distanceDataCollection.order(by: "date", descending: true).limit(to: 1).getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(false)
                    return
                }

                var lastUpdatedDate: Date

                if let querySnapshot = querySnapshot, !querySnapshot.isEmpty, let latestDocument = querySnapshot.documents.first {
                    let latestDateString = latestDocument.get("date") as? String ?? todayDateString
                    lastUpdatedDate = dateFormatter.date(from: latestDateString) ?? dateJoined
                } else {
                    lastUpdatedDate = dateJoined
                }

        
                self.fetchDistanceDatabutton(from: lastUpdatedDate, to: Date()) { distanceData in
                    if distanceData.isEmpty {
                        completion(false)
                        return
                    }

                    if lastUpdatedDate == dateFormatter.date(from: todayDateString) {
                        self.uploadDistanceData(distanceData: distanceData, date: todayDateString, completion: completion)
                    } else {
                        self.uploadDistanceData(distanceData: distanceData, date: dateFormatter.string(from: lastUpdatedDate)) { success in
                            if success {
                                self.uploadMissingDaysDistanceData(distanceData: distanceData, from: dateFormatter.string(from: lastUpdatedDate), to: todayDateString) { success in
                                    if success {
                                        self.uploadDistanceData(distanceData: distanceData, date: todayDateString, completion: completion)
                                    } else {
                                        completion(false)
                                    }
                                }
                            } else {
                                completion(false)
                            }
                        }
                    }
                }
            }
        }
    }


      private func uploadDistanceData(distanceData: [DistanceData], date: String, completion: @escaping (Bool) -> Void) {
          guard let user = Auth.auth().currentUser else {
              completion(false)
              return
          }

          let db = Firestore.firestore()
          let userCollection = db.collection("users").document(user.uid)
          let distanceDataCollection = userCollection.collection("distanceData")

          let filteredDistanceData = distanceData.filter { data in
              return data.date == date
          }

          let totalDistance = filteredDistanceData.reduce(0.0) { $0 + $1.distance }
          let lastUpdatedAt = Timestamp(date: Date())

          let docRef = distanceDataCollection.document(date)

          docRef.getDocument { (document, error) in
              if let document = document, document.exists {
                  docRef.updateData([
                      "distance": totalDistance,
                      "lastUpdatedAt": lastUpdatedAt
                  ]) { error in
                      if let _ = error {
                          completion(false)
                      } else {
                          completion(true)
                      }
                  }
              } else {
                  let dataDict: [String: Any] = [
                      "date": date,
                      "distance": totalDistance,
                      "timestamp": lastUpdatedAt,
                      "lastUpdatedAt": lastUpdatedAt
                  ]

                  docRef.setData(dataDict) { error in
                      if let _ = error {
                          completion(false)
                      } else {
                          
                          completion(true)
                      }
                  }
              }
          }
      }

      private func uploadMissingDaysDistanceData(distanceData: [DistanceData], from startDateString: String, to endDateString: String, completion: @escaping (Bool) -> Void) {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd"
          guard let startDate = dateFormatter.date(from: startDateString),
                let endDate = dateFormatter.date(from: endDateString) else {
              completion(false)
              return
          }

          var currentDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!

          var allUploadsSuccess = true

          let group = DispatchGroup()

          while currentDate <= endDate {
              let currentDateString = dateFormatter.string(from: currentDate)
              let currentDistanceData = distanceData.filter { data in
                  return data.date == currentDateString
              }

              let totalDistance = currentDistanceData.reduce(0.0) { $0 + $1.distance }
              let timestamp = Timestamp(date: Date())

              let dataDict: [String: Any] = [
                  "date": currentDateString,
                  "distance": totalDistance,
                  "timestamp": timestamp,
                  "lastUpdatedAt": timestamp
              ]

              let user = Auth.auth().currentUser!
              let db = Firestore.firestore()
              let userCollection = db.collection("users").document(user.uid)
              let distanceDataCollection = userCollection.collection("distanceData")
              let docRef = distanceDataCollection.document(currentDateString)

              group.enter()

              docRef.setData(dataDict) { error in
                  if let _ = error {
                      allUploadsSuccess = false
                  } else {
                     
                  }
                  group.leave()
              }

              currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
          }

          group.notify(queue: .main) {
              completion(allUploadsSuccess)
          }
      }
}

