//
//  model.swift
//  Runnr
//
//  Created by Archit Kankaria on 08/12/25.
//

struct CurrentGameCard {
    let title: String
    let youName: String
    let friendName: String
    let progress: Float
    let timeLeftText: String
}

struct UpcomingGameCard {
    let title: String
    let upcoming: String
    let youName: String
    let friendName: String
    let progress: Float
    let getReady: String
}

struct CompletedGameCard {
    let title: String
    let completed: String
    let youName: String
    let friendName: String
    let yourBlocks: String
    let friendBlocks: String
    let Winner: String
}

let currentGame: [CurrentGameCard] = [
    CurrentGameCard(title: "Battle Run",
             youName: "You",
             friendName: "Lea",
             progress: 0.6,
             timeLeftText: "⏳  2 days left "),
    CurrentGameCard(title: "Challenge",
             youName: "You",
             friendName: "Riya",
             progress: 0.3,
             timeLeftText: "⏳  5 days left ")
]

let upcomingGame: [UpcomingGameCard] = [
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

let completedGame: [CompletedGameCard] = [
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
