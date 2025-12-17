//
//  model.swift
//  Runnr
//
//  Created by Archit Kankaria on 08/12/25.
//
import Foundation
struct GameCard {
    let title: String        // "Battle Run"
    let youName: String      // "You"
    let friendName: String   // "Lea"
    let progress: Float      // 0.0 ... 1.0
    let timeLeftText: String // "2 days left"
}
let games: [GameCard] = [
    GameCard(title: "Battle Run",
             youName: "You",
             friendName: "Lea",
             progress: 0.6,
             timeLeftText: "⏳  2 days left "),
    GameCard(title: "Challenge",
             youName: "You",
             friendName: "Riya",
             progress: 0.3,
             timeLeftText: "⏳  5 days left ")
]
