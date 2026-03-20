//
//  model.swift
//  Runnr
//
//  Created by Archit Kankaria on 08/12/25.
//

import Foundation
import UIKit

struct TerritoryGame: Codable {
    var gameID: UUID?
    var startDate: Date?
    var endDate: Date?
    var playerOneID: UUID?
    var playerTwoID: UUID?
    var winnerID: UUID?
    var isCompleted: Bool?
}
struct TerritoryHexTile: Codable {
    var tileID: String
    var ownerID: UUID?
    var gameID: UUID
}

enum Player {
    case me, lea
}

enum TileOwner: Equatable {
    case none, player(Player)
}
struct TileState {
    let id: String;
    var owner: TileOwner
}

struct SoloChallenges: Codable {
    let challengeID: UUID
    let title: String
    let description: String
    let rewardPoints: Int
    let SFSymbolName: String
    let goalValue: Int
    let goalUnit: String
    let isActive: Bool
    let difficultyLevel: String
    let challengeType: String
    let totalSessions: Int?
}

struct AssignedChallenges: Codable {
    let userID: UUID
    let challengeID: UUID
    let currentProgress: Int
    let isCompleted: Bool
    let weekStartDate: String
    var rewardClaimed: Bool
}

struct AssignedChallengesProgress: Codable {
    var assignedChallenge: AssignedChallenges
    var challengeDetails: SoloChallenges
}

//struct GetRandomChallengesParams: Encodable, Sendable {
//    let p_user_id: UUID
//    let p_difficulty: String
//}

struct BattleInviteNotification: Codable {
    var notificationID: UUID?
    var senderID: UUID
    var receiverID: UUID
    var senderName: String
    var gameID: UUID?
    var message: String
    var isRead: Bool
    var createdAt: Date?
}
