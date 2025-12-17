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
// DISTANCE
var distanceTrends: [DistanceCardData] = [
    DistanceCardData(trends: "You covered 2.4 km more this week compared to last week"),
    DistanceCardData(trends: "Your total running distance increased steadily over the past 7 days"),
    DistanceCardData(trends: "You exceeded your weekly distance goal by 1.8 km"),
    DistanceCardData(trends: "Your average run distance was longer than last week")
]

// AVERAGE PACE
var averagePaceTrends: [DistanceCardData] = [
    DistanceCardData(trends: "Your average pace improved by 30 seconds per km this week"),
    DistanceCardData(trends: "You maintained a consistent pace across most of your runs"),
    DistanceCardData(trends: "Your fastest run was quicker than your weekly average pace"),
    DistanceCardData(trends: "You ran at a slightly slower pace compared to last week")
]

// CALORIES BURNT
var caloriesBurntTrends: [DistanceCardData] = [
    DistanceCardData(trends: "You burned 220 more calories this week compared to last week"),
    DistanceCardData(trends: "Your average calorie burn per run increased steadily"),
    DistanceCardData(trends: "You reached your highest calorie burn in a single run this week"),
    DistanceCardData(trends: "Your total calories burned remained consistent throughout the week")
]

// STEPS COVERED
var stepsCoveredTrends: [DistanceCardData] = [
    DistanceCardData(trends: "You took 3,500 more steps this week compared to last week"),
    DistanceCardData(trends: "Your daily step count stayed above your weekly average"),
    DistanceCardData(trends: "You achieved your highest step count on one of your runs this week"),
    DistanceCardData(trends: "Your overall step count remained steady across the week")
]


