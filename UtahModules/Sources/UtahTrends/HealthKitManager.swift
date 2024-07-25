////
//// This source file is part of the CS342 2023 Utah Team Application project
////
//// SPDX-FileCopyrightText: 2023 Stanford University
////
//// SPDX-License-Identifier: MIT
////
//import SwiftUI
//import HealthKit
//
//public struct DistanceData: Identifiable {
//    public var id = UUID()
//    public var date: String
//    public var distance: Double
//
//    public init(date: String, distance: Double) {
//        self.date = date
//        self.distance = distance
//    }
//}
//
//public class HealthKitManager: ObservableObject {
//    @Published public var distanceData: [DistanceData] = []
//    @Published public var averageDistance: Double = 0.0
//    static let shared = HealthKitManager()
//    
//    private let healthStore = HKHealthStore()
//    private let queue = DispatchQueue(label: "distancedataqueue", attributes: .concurrent)
//    
//    public init() {
//        Task {
//            do {
//                try await requestAuthorization()
//                await fetchDistanceData()
//            } catch {
//                print("Error requesting HealthKit authorization: \(error)")
//            }
//        }
//    }
//    
//    public func requestAuthorizationIfNeeded() {
//        Task {
//            do {
//                try await requestAuthorization()
//            } catch {
//                print("Error requesting HealthKit authorization: \(error)")
//            }
//        }
//    }
//    
//    public func requestAuthorization() async throws {
//        let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
//        let readDataTypes: Set<HKObjectType> = [distanceType]
//        
//        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
//            healthStore.requestAuthorization(toShare: nil, read: readDataTypes) { success, error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                } else if !success {
//                    continuation.resume(throwing: HealthKitAuthorizationError.authorizationFailed)
//                } else {
//                    continuation.resume(returning: ())
//                }
//            }
//        }
//        print("HealthKit authorization granted.")
//    }
//    public func fetchDistanceData() async {
//        guard HKHealthStore.isHealthDataAvailable() else {
//            print("Health data is not available on this device.")
//            return
//        }
//
//        let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
//        let now = Date()
//        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
//        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
//
//        let distanceQuery = HKStatisticsCollectionQuery(
//            quantityType: distanceType,
//            quantitySamplePredicate: predicate,
//            options: .cumulativeSum,
//            anchorDate: Calendar.current.startOfDay(for: now),
//            intervalComponents: DateComponents(day: 1)
//        )
//
//        let lock = NSLock()
//        var totalDistance: Double = 0.0
//
//        distanceQuery.initialResultsHandler = { [weak self] query, results, error in
//            guard let self = self else { return }
//            if let error = error {
//                print("Failed to fetch distance data: \(error.localizedDescription)")
//                return
//            }
//
//            guard let results = results else {
//                print("No results found.")
//                return
//            }
//
//            var newDistanceData: [DistanceData] = []
//
//            results.enumerateStatistics(from: startDate, to: now) { statistics, stop in
//                if let sum = statistics.sumQuantity() {
//                    let distance = sum.doubleValue(for: HKUnit.mile())
//                    let date = statistics.startDate
//                    let dateString = self.dateFormatter(date: date)
//                    
//                    lock.lock()
//                    totalDistance += distance
//                    lock.unlock()
//                    
//                    newDistanceData.append(DistanceData(date: dateString, distance: distance))
//                } else {
//                    print("No sum quantity found for date: \(statistics.startDate)")
//                }
//            }
//
//            let capturedDistanceData = newDistanceData
//
//            DispatchQueue.main.async {
//                self.distanceData = capturedDistanceData
//                self.averageDistance = capturedDistanceData.isEmpty ? 0 : totalDistance / Double(capturedDistanceData.count)
//            }
//        }
//
//        healthStore.execute(distanceQuery)
//    }
//
//
//    private func dateFormatter(date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM/dd"
//        return formatter.string(from: date)
//    }
//    
//    enum HealthKitAuthorizationError: Error {
//        case dataTypeNotAvailable
//        case authorizationFailed
//    }
//}
//
// New code which includes stepdata
//import SwiftUI
//import HealthKit
//
//public struct DistanceData: Identifiable {
//    public var id = UUID()
//    public var date: String
//    public var distance: Double
//
//    public init(date: String, distance: Double) {
//        self.date = date
//        self.distance = distance
//    }
//}
//
//public struct StepData: Identifiable {
//    public var id = UUID()
//    public var date: String
//    public var steps: Int
//
//    public init(date: String, steps: Int) {
//        self.date = date
//        self.steps = steps
//    }
//}
//
//public class HealthKitManager: ObservableObject {
//    @Published public var distanceData: [DistanceData] = []
//    @Published public var stepData: [StepData] = []
//    @Published public var averageDistance: Double = 0.0
//    @Published public var averageSteps: Double = 0.0
//
//    static let shared = HealthKitManager()
//    
//    private let healthStore = HKHealthStore()
//    private let queue = DispatchQueue(label: "healthdataqueue", attributes: .concurrent)
//    
//    public init() {
//        Task {
//            do {
//                try await requestAuthorization()
//                await fetchDistanceData()
//                await fetchStepData()
//            } catch {
//                print("Error requesting HealthKit authorization: \(error)")
//            }
//        }
//    }
//    
//    public func requestAuthorizationIfNeeded() {
//        Task {
//            do {
//                try await requestAuthorization()
//            } catch {
//                print("Error requesting HealthKit authorization: \(error)")
//            }
//        }
//    }
//    
//    public func requestAuthorization() async throws {
//        let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
//        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
//        let readDataTypes: Set<HKObjectType> = [distanceType, stepType]
//        
//        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
//            healthStore.requestAuthorization(toShare: nil, read: readDataTypes) { success, error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                } else if !success {
//                    continuation.resume(throwing: HealthKitAuthorizationError.authorizationFailed)
//                } else {
//                    continuation.resume(returning: ())
//                }
//            }
//        }
//        print("HealthKit authorization granted.")
//    }
//
//    public func fetchDistanceData() async {
//        guard HKHealthStore.isHealthDataAvailable() else {
//            print("Health data is not available on this device.")
//            return
//        }
//
//        let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
//        let now = Date()
//        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
//        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
//
//        let distanceQuery = HKStatisticsCollectionQuery(
//            quantityType: distanceType,
//            quantitySamplePredicate: predicate,
//            options: .cumulativeSum,
//            anchorDate: Calendar.current.startOfDay(for: now),
//            intervalComponents: DateComponents(day: 1)
//        )
//
//        let lock = NSLock()
//        var totalDistance: Double = 0.0
//
//        distanceQuery.initialResultsHandler = { [weak self] query, results, error in
//            guard let self = self else { return }
//            if let error = error {
//                print("Failed to fetch distance data: \(error.localizedDescription)")
//                return
//            }
//
//            guard let results = results else {
//                print("No results found.")
//                return
//            }
//
//            var newDistanceData: [DistanceData] = []
//
//            results.enumerateStatistics(from: startDate, to: now) { statistics, stop in
//                if let sum = statistics.sumQuantity() {
//                    let distance = sum.doubleValue(for: HKUnit.mile())
//                    let date = statistics.startDate
//                    let dateString = self.dateFormatter(date: date)
//                    
//                    lock.lock()
//                    totalDistance += distance
//                    lock.unlock()
//                    
//                    newDistanceData.append(DistanceData(date: dateString, distance: distance))
//                } else {
//                    print("No sum quantity found for date: \(statistics.startDate)")
//                }
//            }
//
//            let capturedDistanceData = newDistanceData
//
//            DispatchQueue.main.async {
//                self.distanceData = capturedDistanceData
//                self.averageDistance = capturedDistanceData.isEmpty ? 0 : totalDistance / Double(capturedDistanceData.count)
//            }
//        }
//
//        healthStore.execute(distanceQuery)
//    }
//
//    public func fetchStepData() async {
//        guard HKHealthStore.isHealthDataAvailable() else {
//            print("Health data is not available on this device.")
//            return
//        }
//
//        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
//        let now = Date()
//        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
//        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
//
//        let stepQuery = HKStatisticsCollectionQuery(
//            quantityType: stepType,
//            quantitySamplePredicate: predicate,
//            options: .cumulativeSum,
//            anchorDate: Calendar.current.startOfDay(for: now),
//            intervalComponents: DateComponents(day: 1)
//        )
//
//        let lock = NSLock()
//        var totalSteps: Int = 0
//
//        stepQuery.initialResultsHandler = { [weak self] query, results, error in
//            guard let self = self else { return }
//            if let error = error {
//                print("Failed to fetch step data: \(error.localizedDescription)")
//                return
//            }
//
//            guard let results = results else {
//                print("No results found.")
//                return
//            }
//
//            var newStepData: [StepData] = []
//
//            results.enumerateStatistics(from: startDate, to: now) { statistics, stop in
//                if let sum = statistics.sumQuantity() {
//                    let steps = sum.doubleValue(for: HKUnit.count())
//                    let date = statistics.startDate
//                    let dateString = self.dateFormatter(date: date)
//                    
//                    lock.lock()
//                    totalSteps += Int(steps)
//                    lock.unlock()
//                    
//                    newStepData.append(StepData(date: dateString, steps: Int(steps)))
//                    print("Fetched steps: \(steps) for date: \(dateString)")
//                } else {
//                    print("No sum quantity found for date: \(statistics.startDate)")
//                }
//            }
//
//            let capturedStepData = newStepData
//
//            DispatchQueue.main.async {
//                self.stepData = capturedStepData
//                self.averageSteps = capturedStepData.isEmpty ? 0 : Double(totalSteps) / Double(capturedStepData.count)
//                print("Captured step data: \(capturedStepData)")
//            }
//        }
//
//        healthStore.execute(stepQuery)
//    }
//
//
//    private func dateFormatter(date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM/dd"
//        return formatter.string(from: date)
//    }
//    
//    enum HealthKitAuthorizationError: Error {
//        case dataTypeNotAvailable
//        case authorizationFailed
//    }
//}
//

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
               
            } catch {
                print("Error requesting HealthKit authorization: \(error)")
            }
        }
    }

    
    public func requestAuthorizationIfNeeded() {
        Task {
            do {
                try await requestAuthorization()
            } catch {
                print("Error requesting HealthKit authorization: \(error)")
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
        print("HealthKit authorization granted.")
    }
    
    public func fetchDistanceData() async {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data is not available on this device.")
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
                print("Failed to fetch distance data: \(error.localizedDescription)")
                return
            }

            guard let results = results else {
                print("No results found.")
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
                    print("No sum quantity found for date: \(statistics.startDate)")
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
            print("Captured distance data: \(newDistanceData)")
        }
    }


//    public func fetchStepData() async {
//        guard HKHealthStore.isHealthDataAvailable() else {
//            print("Health data is not available on this device.")
//            return
//        }
//
//        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
//        let now = Date()
//        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
//        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
//
//        let stepQuery = HKStatisticsCollectionQuery(
//            quantityType: stepType,
//            quantitySamplePredicate: predicate,
//            options: .cumulativeSum,
//            anchorDate: Calendar.current.startOfDay(for: now),
//            intervalComponents: DateComponents(day: 1)
//        )
//
//        let lock = NSLock()
//        var totalSteps: Int = 0
//
//        stepQuery.initialResultsHandler = { [weak self] query, results, error in
//            guard let self = self else { return }
//            if let error = error {
//                print("Failed to fetch step data: \(error.localizedDescription)")
//                return
//            }
//
//            guard let results = results else {
//                print("No results found.")
//                return
//            }
//
//            var newStepData: [StepData] = []
//
//            results.enumerateStatistics(from: startDate, to: now) { statistics, stop in
//                if let sum = statistics.sumQuantity() {
//                    let steps = sum.doubleValue(for: HKUnit.count())
//                    let date = statistics.startDate
//                    let dateString = self.dateFormatter(date: date)
//                    
//                    lock.lock()
//                    totalSteps += Int(steps)
//                    lock.unlock()
//                    
//                    newStepData.append(StepData(date: dateString, steps: Int(steps)))
//                    print("Fetched steps: \(steps) for date: \(dateString)")
//                } else {
//                    print("No sum quantity found for date: \(statistics.startDate)")
//                }
//            }
//
//            DispatchQueue.main.async {
//                self.stepData = newStepData
//                self.averageSteps = newStepData.isEmpty ? 0 : Double(totalSteps) / Double(newStepData.count)
//                print("Captured step data: \(newStepData)")
//            }
//        }
//
//        healthStore.execute(stepQuery)
//    }
    public func fetchStepData() async {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data is not available on this device.")
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
                print("Failed to fetch step data: \(error.localizedDescription)")
                return
            }

            guard let results = results else {
                print("No results found.")
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
                    print("Fetched steps: \(steps) for date: \(dateString)")
                } else {
                    print("No sum quantity found for date: \(statistics.startDate)")
                }
            }

            // Call a separate method to handle the main thread updates
            self.updateStepDataOnMainThread(newStepData: tempStepData, totalSteps: tempTotalSteps)
        }

        healthStore.execute(stepQuery)
    }

    private func updateStepDataOnMainThread(newStepData: [StepData], totalSteps: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.stepData = newStepData
            self.averageSteps = newStepData.isEmpty ? 0 : Double(totalSteps) / Double(newStepData.count)
            print("Captured step data: \(newStepData)")
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
 
    public func StepCountCollectionExistsAndUpload(stepData: [StepData], completion: @escaping (Bool) -> Void) {
         guard let user = Auth.auth().currentUser else {
             print("User not logged in")
             completion(false)
             return
         }

         let db = Firestore.firestore()
         let userCollection = db.collection("users").document(user.uid)
         let stepCountCollection = userCollection.collection("stepCountData")

         stepCountCollection.order(by: "date", descending: true).limit(to: 1).getDocuments { (querySnapshot, error) in
             if let error = error {
                 print("Error checking step count collection: \(error)")
                 completion(false)
                 return
             }

             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "yyyy-MM-dd"
             let todayDateString = dateFormatter.string(from: Date())

             if let querySnapshot = querySnapshot, !querySnapshot.isEmpty, let latestDocument = querySnapshot.documents.first {
                 let latestDate = latestDocument.get("date") as? String ?? ""

                 if latestDate == todayDateString {
                     // Here we update today's document
                     self.uploadStepCountData(stepData: stepData, date: todayDateString, completion: completion)
                 } else {
                     // if it's not the latest dates data, we update previous day's document, then upload missing days and today's data
                     self.uploadStepCountData(stepData: stepData, date: latestDate) { success in
                         if success {
                             self.uploadMissingDaysStepData(stepData: stepData, from: latestDate, to: todayDateString) { success in
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
             } else {
                 // if there is no collection for a particular user, create document for that day
                 self.uploadStepCountData(stepData: stepData, date: todayDateString, completion: completion)
             }
         }
     }

     private func uploadStepCountData(stepData: [StepData], date: String, completion: @escaping (Bool) -> Void) {
         guard let user = Auth.auth().currentUser else {
             print("User not logged in")
             completion(false)
             return
         }

         let db = Firestore.firestore()
         let userCollection = db.collection("users").document(user.uid)
         let stepCountCollection = userCollection.collection("stepCountData")

         // Filter stepData to only include steps for the given date
         let filteredStepData = stepData.filter { data in
             return data.date == date
         }

         let totalSteps = filteredStepData.reduce(0) { $0 + $1.steps }
         let lastUpdatedAt = Timestamp(date: Date())

         let docRef = stepCountCollection.document(date)

         // let's fetch the document to check if it exists
         docRef.getDocument { (document, error) in
             if let document = document, document.exists {
                 // Document exists,  it updates the steps from the time it was lastupdated
                 docRef.updateData([
                     "steps": totalSteps,
                     "lastUpdatedAt": lastUpdatedAt
                 ]) { error in
                     if let error = error {
                         print("Error updating step count data for \(date): \(error)")
                         completion(false)
                     } else {
                         print("Step count data updated successfully for \(date)")
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
                     if let error = error {
                         print("Error creating step count data for \(date): \(error)")
                         completion(false)
                     } else {
                         print("Step count data created successfully for \(date)")
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

         var currentDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!

         var allUploadsSuccess = true

         let group = DispatchGroup()

         while currentDate <= endDate {
             let currentDateString = dateFormatter.string(from: currentDate)
             let currentStepData = stepData.filter { data in
                 return data.date == currentDateString
             }

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

             docRef.setData(dataDict) { error in
                 if let error = error {
                     print("Error creating step count data for \(currentDateString): \(error)")
                     allUploadsSuccess = false
                 } else {
                     print("Step count data created successfully for \(currentDateString)")
                 }
                 group.leave()
             }

             currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
         }

         group.notify(queue: .main) {
             completion(allUploadsSuccess)
         }
     }
    

      public func DistanceDataCollectionExistsAndUpload(distanceData: [DistanceData], completion: @escaping (Bool) -> Void) {
          guard let user = Auth.auth().currentUser else {
              print("User not logged in")
              completion(false)
              return
          }

          let db = Firestore.firestore()
          let userCollection = db.collection("users").document(user.uid)
          let distanceDataCollection = userCollection.collection("distanceData")

          distanceDataCollection.order(by: "date", descending: true).limit(to: 1).getDocuments { (querySnapshot, error) in
              if let error = error {
                  print("Error checking distance data collection: \(error)")
                  completion(false)
                  return
              }

              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "yyyy-MM-dd"
              let todayDateString = dateFormatter.string(from: Date())

              if let querySnapshot = querySnapshot, !querySnapshot.isEmpty, let latestDocument = querySnapshot.documents.first {
                  let latestDate = latestDocument.get("date") as? String ?? ""

                  if latestDate == todayDateString {
                      // Here we update today's document
                      self.uploadDistanceData(distanceData: distanceData, date: todayDateString, completion: completion)
                  } else {
                      // if it's not the latest dates data, we update previous day's document, then upload missing days and today's data
                      self.uploadDistanceData(distanceData: distanceData, date: latestDate) { success in
                          if success {
                              self.uploadMissingDaysDistanceData(distanceData: distanceData, from: latestDate, to: todayDateString) { success in
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
              } else {
                  // if there is no collection for a particular user, create document for that day
                  self.uploadDistanceData(distanceData: distanceData, date: todayDateString, completion: completion)
              }
          }
      }

      private func uploadDistanceData(distanceData: [DistanceData], date: String, completion: @escaping (Bool) -> Void) {
          guard let user = Auth.auth().currentUser else {
              print("User not logged in")
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
                      if let error = error {
                          print("Error updating distance data for \(date): \(error)")
                          completion(false)
                      } else {
                          print("Distance data updated successfully for \(date)")
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
                      if let error = error {
                          print("Error creating distance data for \(date): \(error)")
                          completion(false)
                      } else {
                          print("Distance data created successfully for \(date)")
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
                  if let error = error {
                      print("Error creating distance data for \(currentDateString): \(error)")
                      allUploadsSuccess = false
                  } else {
                      print("Distance data created successfully for \(currentDateString)")
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
