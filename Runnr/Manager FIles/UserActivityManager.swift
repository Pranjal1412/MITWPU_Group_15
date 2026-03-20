//
//  UserActivityManager.swift
//  Runnr
//
//  Created by Pranjal Shinde on 23/12/25.
//

import Foundation
import UIKit
import CoreLocation
import CoreMotion

class UserActivityManager {

    let datasource = DataSource.shared
    
    private var timer: Timer?
    private var startTime: Date?
    private var accumulatedTime: TimeInterval = 0
    private var timerLabel : UILabel
    
    private var totalTime: TimeInterval = 0
    var seconds: Int = 0
    var minutes: Int = 0
    var hours: Int = 0
    
    private var distanceLastLocation: CLLocation?
    var totalDistance: Double = 0.0
    
    // Elevation tracking
    private var elevationLastLocation: CLLocation?
    private var totalElevationGain: Double = 0.0
    
    private let pedometer = CMPedometer()
    private var steps : Int = 0
    var totalSteps: Int = 0
    
    private var avgPace : Double = 0.0
    private var liveDistance: Double = 0
    private var liveTime: TimeInterval = 0
    private var paceLastLocation: CLLocation?
    var currentPace : Double = 0.0
    
    private var graphDistance: Double = 0
    private var graphTime: TimeInterval = 0
    private var graphDistancePoint: Int = 0
    var paceGraphData: [ActivityPaceGraphData] = []
    
    init (timerLabel: UILabel) {
        self.timerLabel = timerLabel
    }
    
    func startTimer() {
        self.startTime = Date()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }

    func getTotalTime() -> Int {
        return Int(totalTime)
    }
    
    func getTotalElevation() -> Double {
        return totalElevationGain
    }
    
    func stopTimer() {
        if let start = startTime {
            accumulatedTime += Date().timeIntervalSince(start)
        }
        print("Hours: \(hours), Minutes: \(minutes), Seconds: \(seconds)")
        timer?.invalidate()
        timer = nil
    }

    @objc func updateTime() {
        if let start = startTime {
            totalTime = accumulatedTime + Date().timeIntervalSince(start)
            let formattedTime = formatTime(Int(totalTime))
            timerLabel.text = String(format: "%02d:%02d:%02d", formattedTime.hour, formattedTime.minute, formattedTime.second)
        }
    }
    
    func startUpdatingDistance(with location: CLLocation) {
        if let last = self.distanceLastLocation {
            totalDistance += location.distance(from: last) / 1000
        }
        self.distanceLastLocation = location
    }
    
    func stopUpdatingDistance() {
        self.distanceLastLocation = nil
    }
    
    // MARK: - Elevation Update
    func startUpdatingElevation(with location: CLLocation) {
        guard location.verticalAccuracy > 0 && location.verticalAccuracy < 15 else {
            print("⛰ Skipped — verticalAccuracy: \(location.verticalAccuracy)")
            return
        }
        
        if let last = elevationLastLocation {
            let delta = location.altitude - last.altitude
            if delta > 5.0 {
                totalElevationGain += delta
                print("⛰ Elevation gained: \(delta) | Total: \(totalElevationGain)")
            }
        }
        
        elevationLastLocation = location
    }
    
    func stopUpdatingElevation() {
        // Reset on pause/stop so bad delta isn't calculated on resume
        elevationLastLocation = nil
    }
    
    func startStepsTracking() {
        if CMPedometer.isStepCountingAvailable() {
            pedometer.startUpdates(from: Date()) { data, error in
                if let data = data, error == nil {
                    self.steps = data.numberOfSteps.intValue
                    print("Steps:", self.steps)
                }
            }
        }
    }
    
    func stopStepsTracking() {
        pedometer.stopUpdates()
        totalSteps += steps
        steps = 0
    }
    
    func showLivePace(using location: CLLocation) {

        if let last = self.paceLastLocation {

            let deltaDistance = location.distance(from: last)
            let deltaTime = location.timestamp.timeIntervalSince(last.timestamp)

            if deltaDistance > 0 && deltaTime > 0 {
                self.liveDistance += deltaDistance
                self.liveTime += deltaTime

                if self.liveTime >= 30 && self.liveDistance > 50 {
                    self.currentPace = (self.liveTime / self.liveDistance) * 1000 / 60
                    self.liveDistance = 0
                    self.liveTime = 0
                }

                self.graphDistance += deltaDistance
                self.graphTime += deltaTime

                if self.graphDistance >= 500 {
                    let pace = (self.graphTime / self.graphDistance) * 1000 / 60
                    self.graphDistancePoint += 500
                    self.paceGraphData.append(ActivityPaceGraphData(distanceValue: Double(graphDistancePoint) / 1000, paceValue: pace))
                    self.graphDistance = 0
                    self.graphTime = 0
                }
            }
        }

        self.paceLastLocation = location
    }

    func getAveragePace() -> Double {
        self.datasource.setCurrentActivityPaceData(self.paceGraphData)
        if totalDistance > 0 && totalTime >= 60 {
            self.avgPace = (totalTime / 60) / totalDistance
        }
        return self.avgPace
    }
    
    func skillPointsEarned() -> Int {
        switch self.avgPace {
        case 0:       return 0
        case 1..<4:   return 100
        case 4..<7:   return 50
        case 7..<9:   return 30
        case 9..<17:  return 10
        default:      return 10
        }
    }
    
    func basePointsEarned() -> Int {
        return (Int(totalDistance) * (Int(totalDistance) + 1)) * 5
    }
    
    func restoreTime(seconds: Int) {
        self.accumulatedTime = TimeInterval(seconds)
        self.startTime = nil
    }
    
    func getFormattedTime() -> String {
        let totalSeconds: Int
        if let start = startTime {
            totalSeconds = Int(accumulatedTime + Date().timeIntervalSince(start))
        } else {
            totalSeconds = Int(accumulatedTime)
        }
        let hrs = totalSeconds / 3600
        let mins = (totalSeconds % 3600) / 60
        let secs = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hrs, mins, secs)
    }
    
    func estimatedCalories(activityType: ActivityType) -> Int {
        let weightKg = datasource.getUserProfile().weight ?? 70.0
        let met: Double
        switch activityType {
        case .walking:  met = 3.5
        case .hiking:   met = 6.0
        case .marathon: met = 13.5
        default:        met = 8.0
        }
        let hours = totalTime / 3600
        return Int(met * weightKg * hours)
    }
}
