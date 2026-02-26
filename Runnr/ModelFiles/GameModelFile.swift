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
