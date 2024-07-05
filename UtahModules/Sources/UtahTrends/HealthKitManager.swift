//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import SwiftUI
import HealthKit

public struct DistanceData: Identifiable {
    public var id = UUID()
    public var date: String
    public var distance: Double

    public init(date: String, distance: Double) {
        self.date = date
        self.distance = distance
    }
}

public class HealthKitManager: ObservableObject {
    @Published public var distanceData: [DistanceData] = []
    @Published public var averageDistance: Double = 0.0
    static let shared = HealthKitManager()
    
    private let healthStore = HKHealthStore()
    private let queue = DispatchQueue(label: "distancedataqueue", attributes: .concurrent)
    
    public init() {
        Task {
            do {
                try await requestAuthorization()
                await fetchDistanceData()
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
        let readDataTypes: Set<HKObjectType> = [distanceType]
        
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

        let lock = NSLock()
        var totalDistance: Double = 0.0

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

            var newDistanceData: [DistanceData] = []

            results.enumerateStatistics(from: startDate, to: now) { statistics, stop in
                if let sum = statistics.sumQuantity() {
                    let distance = sum.doubleValue(for: HKUnit.mile())
                    let date = statistics.startDate
                    let dateString = self.dateFormatter(date: date)
                    
                    lock.lock()
                    totalDistance += distance
                    lock.unlock()
                    
                    newDistanceData.append(DistanceData(date: dateString, distance: distance))
                } else {
                    print("No sum quantity found for date: \(statistics.startDate)")
                }
            }

            let capturedDistanceData = newDistanceData

            DispatchQueue.main.async {
                self.distanceData = capturedDistanceData
                self.averageDistance = capturedDistanceData.isEmpty ? 0 : totalDistance / Double(capturedDistanceData.count)
            }
        }

        healthStore.execute(distanceQuery)
    }


    private func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
    
    enum HealthKitAuthorizationError: Error {
        case dataTypeNotAvailable
        case authorizationFailed
    }
}

