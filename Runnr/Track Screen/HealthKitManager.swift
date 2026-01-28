//
//  HealthKitManager.swift
//  Runnr
//
//  Created by SDC-USER on 27/01/26.
//

import HealthKit

final class HealthKitManager {

    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()

    func requestPermission(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }

//        the data app wants to get
        let readTypes: [HKObjectType] = [HKObjectType.quantityType(forIdentifier: .heartRate)!
            /*HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!*/]

//        toShare parameter is empty as there is no data that app needs to write to healthKit, while read has the data app wants access
        healthStore.requestAuthorization(toShare: [], read: Set(readTypes)) { success, _ in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    func fetchAverageHeartRate(from start: Date, to end: Date, completion: @escaping (Double?) -> Void) {

        guard let type = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            completion(nil)
            return
        }
        
// tells the healthKit to give only heart-rate samples recorded between start and end, strictStartDate means that the data should be strictly after start time
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

//        predicate is a filter, type is .heartRate, discreteAverage calculates the avgHeartRate
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, _ in

//            averageQuantity() → gets the average; Convert it to beats per minute, Returns a Double
            let avg = result?.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))

//            avg will be nil if watch permission not given or access is denied
            DispatchQueue.main.async {
                completion(avg)
            }
        }

        healthStore.execute(query)
    }
}
