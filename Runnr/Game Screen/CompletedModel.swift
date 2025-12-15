//
//  model.swift
//  Runnr
//
//  Created by Archit Kankaria on 08/12/25.
//
import Foundation

struct CompletedGameCard {
    let title: String// "Battle Run"
    let completed: String
    let youName: String      // "You"
    let friendName: String// "Lea"
    let yourBlocks: String
    let friendBlocks: String
    let Winner: String
}
let CompletedGame: [CompletedGameCard] = [
    CompletedGameCard(title: "Battle Run",
             completed: "Completed",
             youName: "You",
             friendName: "John",
             yourBlocks: "Area Captured: 5 blocks",
             friendBlocks: "Area Captured: 8 blocks",
             Winner: "John Wins!"),
    CompletedGameCard(title: "Battle Run",
                      completed: "Completed",
                      youName: "You",
                      friendName: "Rhea",
                      yourBlocks: "Area Captured: 10 blocks",
                      friendBlocks: "Area Captured: 8 blocks",
                      Winner: "You Win!")
]


