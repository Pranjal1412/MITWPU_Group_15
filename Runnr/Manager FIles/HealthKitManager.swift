import HealthKit

final class HealthKitManager {
    
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()
    
    // 1. Request Permission (Read-only)
    func requestPermission(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }
        
        let typesToRead: Set = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, _ in
            DispatchQueue.main.async { completion(success) }
        }
    }
    
    // 2. Fetch Calories (Sum for the run duration)
    func fetchCalories(from start: Date, to end: Date, completion: @escaping (Double) -> Void) {
        guard let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(0)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: calorieType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let total = result?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
            DispatchQueue.main.async { completion(total) }
        }
        healthStore.execute(query)
    }
    
    // 3. Fetch Heart Rate (Average for the run duration)
    private func fetchAverageHeartRate(from start: Date, to end: Date, completion: @escaping (Double?) -> Void) {

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
    
    func fetchAverageHeartRateAsync(from start: Date, to end: Date) async -> Double? {

        await withCheckedContinuation { continuation in
            fetchAverageHeartRate(from: start, to: end) { avgHR in
                continuation.resume(returning: avgHR)
            }
        }
    }
    func fetchCaloriesAsync(from start: Date, to end: Date) async -> Double {
        await withCheckedContinuation { continuation in
            fetchCalories(from: start, to: end) { calories in
                continuation.resume(returning: calories)
            }
        }
    }
}
