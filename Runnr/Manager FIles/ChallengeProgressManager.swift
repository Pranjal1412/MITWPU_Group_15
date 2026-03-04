//
//  ChallengeProgressManager.swift
//  Runnr
//
//  Created by SDC-USER on 04/03/26.
//
//import Foundation
//
//class ChallengeProgressManager {
//
//    func calculateProgress(for challenge: SoloChallenges, userStats: UserStats) -> Double {
//
//        switch challenge.challengeType {
//
//        case "Total_day_weekly":
//            return Double(userStats.activeDaysThisWeek) / Double(challenge.goalValue)
//
//        case "Total_distance_weekly":
//            return userStats.totalDistanceThisWeek / Double(challenge.goalValue)
//
//        case "Total_activities_weekly":
//            return Double(userStats.totalActivitiesThisWeek) / Double(challenge.goalValue)
//
//        case "Total_distance_oneSession":
//            return userStats.longestSessionDistance / Double(challenge.goalValue)
//
//        case "Total_time_weekly":
//            return userStats.totalTimeThisWeek / Double(challenge.goalValue)
//
//        case "Total_time_oneSession":
//            return userStats.longestSessionTime / Double(challenge.goalValue)
//
//        default:
//            return 0
//        }
//    }
//}
