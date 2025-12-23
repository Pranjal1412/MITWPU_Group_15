//
//  UserActivityManager.swift
//  Runnr
//
//  Created by Pranjal Shinde on 23/12/25.
//

import Foundation
import UIKit

class UserActivityManager {

    var timer: Timer?
    var startTime: Date?
    var accumulatedTime: TimeInterval = 0
    var timerLabel : UILabel
    
    init (timerLabel: UILabel) {
        self.timerLabel = timerLabel
    }
    
    var seconds: Int = 0
    var minutes: Int = 0
    var hours: Int = 0
    
    var timeStamp : String?

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
            let totalTime = accumulatedTime + Date().timeIntervalSince(start)
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
}
