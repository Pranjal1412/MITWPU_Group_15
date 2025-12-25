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

    var timer: Timer?
    var startTime: Date?
    var accumulatedTime: TimeInterval = 0
    var timerLabel : UILabel
    var timeStamp : String?
    
    var totalTime: TimeInterval = 0
    var seconds: Int = 0
    var minutes: Int = 0
    var hours: Int = 0
    
    var totalDistance: Double = 0.0
    var distance : Double = 0.0
    var lastLocation : CLLocation?
    
    let pedometer = CMPedometer()
    var totalSteps: Int = 0
    var steps : Int = 0
    
    var livePace : Double = 0.0
    
    init (timerLabel: UILabel) {
        self.timerLabel = timerLabel
    }
    
    func activityTimeStamp() {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        timeStamp = formatter.string(from: Date())
    }
    
    // same function for resuming the timer if activity is just paused
    func startTimer() {
        startTime = Date()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }

    // same function for completely stopping the timer after activity is been ended
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
            timerLabel.text = formatTime(totalTime)
        }
    }

    func formatTime(_ interval: TimeInterval) -> String {
        let totalSeconds = Int(interval)
        
        seconds = totalSeconds % 60
        minutes = (totalSeconds % 3600) / 60
        hours = totalSeconds / 3600
    
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func startUpdatingDistance(with location: CLLocation) {
        if let last = lastLocation {
            distance += location.distance(from: last) / 1000
        }
        
        lastLocation = location
    }
    
    func stopUpdatingDistance() {
        totalDistance += distance
        distance = 0
        lastLocation = nil
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
        let speed = location.speed // unit here is meter/seconds
        
        if speed > 0 {
            livePace = (1000/speed) / 60 // unit converted to min/km
            print("Pace:", livePace)
        }
    }

    func getAveragePace() -> Double {
        
        if totalDistance >= 0.1 && totalTime >= 60 {
            return (totalTime / 60) / distance
        }
        
        return 0.00
    }
    
}
