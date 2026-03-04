//
//  DistanceCardData.swift
//  Runnr
//
//  Created by Nidhi Aralkar on 10/12/25.
//

import Foundation

struct DistanceCardData {
    let trends: String
}

struct CardData {
    var number: String
    let unit : String
    let title: String
    var trend: String
    var trendChevron: String
}

struct DayData: Identifiable, Equatable {
    let id = UUID()
    let label: String
    let value: Double
}

struct TotalValue {
    let totalDistance: Double
    let totalCalories: Double
    let totalPace: Double
    let totalSteps: Double
}

struct SummaryRow: Decodable {
    // Supabase returns dates as Strings (ISO8601)
    private let timeGroup: String
    let distance: Double
    let calories: Int
    let steps: Int
    let pace: Double

    // Use this in your UI
    var date: Date {
        let formatter = DateFormatter()
        // This matches your specific string: "YYYY-MM-DDTHH:MM:SS"
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        // Set locale to ensure it doesn't break on users with non-US settings
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        if let parsedDate = formatter.date(from: timeGroup) {
            return parsedDate
        }

        // If it still fails, use a "Sentinel" date so you know it's broken
        // (Jan 1 1970 will show up as 'Thu' or '1970')
        return Date(timeIntervalSince1970: 0)
    }
    
    enum CodingKeys: String, CodingKey {
        case timeGroup = "timeGroup" // Matches the quoted SQL name exactly
        case distance, calories, steps, pace
    }
}

// DISTANCE
//var distanceTrends: [DistanceCardData] = [
//    DistanceCardData(trends: "You covered 2.4 km more this week compared to last week"),
//    DistanceCardData(trends: "Your total running distance increased steadily over the past 7 days"),
//    DistanceCardData(trends: "You exceeded your weekly distance goal by 1.8 km"),
//    DistanceCardData(trends: "Your average run distance was longer than last week")
//]

// AVERAGE PACE
//var averagePaceTrends: [DistanceCardData] = [
//    DistanceCardData(trends: "Your average pace improved by 30 seconds per km this week"),
//    DistanceCardData(trends: "You maintained a consistent pace across most of your runs"),
//    DistanceCardData(trends: "Your fastest run was quicker than your weekly average pace"),
//    DistanceCardData(trends: "You ran at a slightly slower pace compared to last week")
//]

// CALORIES BURNT
//var caloriesBurntTrends: [DistanceCardData] = [
//    DistanceCardData(trends: "You burned 220 more calories this week compared to last week"),
//    DistanceCardData(trends: "Your average calorie burn per run increased steadily"),
//    DistanceCardData(trends: "You reached your highest calorie burn in a single run this week"),
//    DistanceCardData(trends: "Your total calories burned remained consistent throughout the week")
//]

// STEPS COVERED
//var stepsCoveredTrends: [DistanceCardData] = [
//    DistanceCardData(trends: "You took 3,500 more steps this week compared to last week"),
//    DistanceCardData(trends: "Your daily step count stayed above your weekly average"),
//    DistanceCardData(trends: "You achieved your highest step count on one of your runs this week"),
//    DistanceCardData(trends: "Your overall step count remained steady across the week")
//]


