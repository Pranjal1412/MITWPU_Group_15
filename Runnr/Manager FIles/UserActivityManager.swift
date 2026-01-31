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

    private var timer: Timer?
    private var startTime: Date?
    private var accumulatedTime: TimeInterval = 0
    private var timerLabel : UILabel
    
    private var totalTime: TimeInterval = 0
    var seconds: Int = 0
    var minutes: Int = 0
    var hours: Int = 0
    
    private var distanceLastLocation: CLLocation?
    var totalDistance: Double = 1.0
    
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
    var paceGraphData: [LivePaceGraphData] = []
    
    init (timerLabel: UILabel) {
        self.timerLabel = timerLabel
    }
    
    // same function for resuming the timer if activity is just paused
    func startTimer() {
        self.startTime = Date()
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
        if let last = self.distanceLastLocation {
            totalDistance += location.distance(from: last) / 1000
        }
        
        self.distanceLastLocation = location
    }
    
    func stopUpdatingDistance() {
        self.distanceLastLocation = nil
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

            print("Inside showLivePace")
            print("Current:", location.timestamp)
            print("Last:", last.timestamp)

            let deltaDistance = location.distance(from: last)
            let deltaTime = location.timestamp.timeIntervalSince(last.timestamp)

            print("deltaDistance: \(deltaDistance), deltaTime: \(deltaTime)")
            if deltaDistance > 0 && deltaTime > 0 {
                self.liveDistance += deltaDistance
                self.liveTime += deltaTime
                print("liveDistance: \(liveDistance), liveTime: \(liveTime) -> outside if")

                if self.liveTime >= 30 && self.liveDistance > 1 {
                    self.currentPace = (self.liveTime / self.liveDistance) * 1000 / 60
                    print("liveDistance: \(liveDistance), liveTime: \(liveTime) -> inside if")

                    self.liveDistance = 0
                    self.liveTime = 0
                }

                self.graphDistance += deltaDistance
                self.graphTime += deltaTime
                print("graphDistance: \(graphDistance), graphTime: \(graphTime) -> outside if")

                if self.graphDistance >= 100 {
                    let pace = (self.graphTime / self.graphDistance) * 1000 / 60

                    self.graphDistancePoint += 100
                    self.paceGraphData.append(LivePaceGraphData(paceValue: pace, distance: Double(graphDistancePoint) / 1000, symbol: graphDistancePoint % 1000 == 0))
                    print("graphDistance: \(graphDistance), graphTime: \(graphTime) -> inside if")
                    self.graphDistance = 0
                    self.graphTime = 0
                }
                
            }
        }

        self.paceLastLocation = location
    }


    func getAveragePace() -> Double {
        
        if totalDistance > 0 && totalTime >= 60 {
            self.avgPace = (totalTime / 60) / totalDistance
        }
        
        return self.avgPace
    }
    
    func skillPointsEarned() -> Int {
        switch self.avgPace {
            
            case 0:
                return 0
            case 1..<4:
                return 100
                
            case 4..<7:
                return 50
                
            case 7..<9:
                return 30
            
            case 9..<17:
                return 10
            
            default:
                return 10
        }
    }
    
    func basePointsEarned() -> Int {
        return (Int(totalDistance) * (Int(totalDistance) + 1)) * 5
    }
}
