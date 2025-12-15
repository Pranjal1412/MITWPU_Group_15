//
//  model.swift
//  Runnr
//
//  Created by Archit Kankaria on 08/12/25.
//
import Foundation

struct UpcomingGameCard {
    let title: String// "Battle Run"
    let upcoming: String
    let youName: String      // "You"
    let friendName: String   // "Lea"
    let progress: Float      // 0.0 ... 1.0
    let getReady: String
}
let UpcomingGame: [UpcomingGameCard] = [
    UpcomingGameCard(title: "Battle Run",
             upcoming: "Upcoming",
             youName: "You",
             friendName: "Lea",
             progress: 0.0,
             getReady: "Get ready to compete!"),
    UpcomingGameCard(title: "Battle Run",
             upcoming: "20/1/2026",
             youName: "You",
             friendName: "Riya",
             progress: 0.0,
             getReady: "Battle starts soon, be prepared!"),
    UpcomingGameCard(title: "Battle Run",
             upcoming: "28/2/2026",
             youName: "You",
             friendName: "Aarav",
             progress: 0.0,
             getReady: "Theres still time, just a little longer!")
    
]

