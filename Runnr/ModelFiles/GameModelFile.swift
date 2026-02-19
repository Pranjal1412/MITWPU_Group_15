//
//  model.swift
//  Runnr
//
//  Created by Archit Kankaria on 08/12/25.
//
import Foundation
import UIKit

struct TerritoryGameModel: Codable {
    let gameID: UUID
    let startDate: Date
    let endDate: Date
    let playerOneID: UUID
    let playerTwoID: UUID
    var winnerID: UUID?
    var isCompleted: Bool
}
struct TileStatus: Codable {
    let tileID: String
    var ownerID: UUID?
    let gameID: UUID
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
