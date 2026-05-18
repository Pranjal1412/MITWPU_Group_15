//
//  clubData.swift
//  Runnr
//
//  Created by SDC-USER on 25/11/25.
//

import Foundation
import UIKit

struct Club: Codable {
    var clubID: UUID?
    var clubOwnerID: UUID?
    var clubName: String?
    var clubProfileImageURL: String?
    var clubBannerImageURL: String?
    var clubMotive: String?
    var clubDescription: String?
    var clubSport: ActivityType?
    var isPublic: Bool?
    var memberCount: Int?
}

struct ClubEvents : Codable {
    var eventID: UUID?         // primary key of ScheduledClubEvents (column name: "id")
    var clubID: UUID?
    var eventName: String?
    var eventDescription: String?
    var eventDate: Date?
    var startTime: String?
    var endTime: String?
    var startLocation: String?
    var endLocation: String?
    var isCompleted: Bool?

    // Supabase column is "id", but we use eventID in Swift
    enum CodingKeys: String, CodingKey {
        case eventID        = "id"
        case clubID
        case eventName
        case eventDescription
        case eventDate
        case startTime
        case endTime
        case startLocation
        case endLocation
        case isCompleted
    }
}

// MARK: - Poll Types

enum PollVoteType: String, Codable {
    case joining  = "joining"
    case maybe    = "maybe"
    case notGoing = "not_going"
}

/// Stored in Supabase `EventPollVote` table.
struct EventPollVote: Codable {
    var voteID:   UUID?
    var eventID:  UUID?
    var userID:   UUID?
    var voteType: PollVoteType
}

/// In-memory summary of poll results for one event.
struct EventPollSummary {
    var joiningCount:  Int
    var maybeCount:    Int
    var notGoingCount: Int
    var myVote:        PollVoteType?  // nil = current user hasn't voted
}

struct ClubMemberRole : Codable {
    var userID : UUID?
    var clubID : UUID?
    var role : ClubRoleType
}

struct ClubRoleAndData : Codable {
    var role : ClubRoleType
    var club : Club
}

struct ClubPost : Codable {
    var postID : UUID?
    var clubID : UUID?
    var postOwner: UUID?
    var caption : String
    var postImageURL: String?
    var likeCount: Int
    var createdTimestamp: Date
}

struct ClubPostDetail {
    var postOwner: UserProfile
    var post: ClubPost
}

struct ClubPostImage : Codable {
    var imageID : UUID?
    var postID : UUID?
    var imageURL : String?
    var sequence : Int
}

struct ClubTaggedPost : Codable {
    var activityID : UUID?
    var clubID : UUID?
}

struct FollowerAndFollowing: Codable {
    var FollowerID: UUID
    var FollowingID: UUID
}

let clubActivityOptions : [ClubActivityOptions] = [
    ClubActivityOptions(image: UIImage(systemName: "figure.run")!, title: .running),
    ClubActivityOptions(image: UIImage(systemName: "figure.hiking")!, title: .hiking),
    ClubActivityOptions(image: UIImage(systemName: "figure.walk")!, title: .walking),
    ClubActivityOptions(image: UIImage(systemName: "figure.highintensity.intervaltraining")!, title: .marathon)]

let clubDescriptions: [String] = ["Just for fun!", "Competitive Play", "Fitness", "Charity"]


// MARK: - Below things are hidden currently
struct LeaderBoard {
    let badge: String
    let levelName: String
    let levelDescription: String
}

struct LeaderboardUser {
    let name: String
    let profileImageName: String
    let kilometers: Int
    let streak: Int
    let points: Int
}

enum LeaderboardMode {
    case kilometer
    case streak
    case points
}

struct ClubActivityOptions {
    let image : UIImage
    let title :  ActivityType
}

let leaderBoardArray: [LeaderBoard] = [
LeaderBoard(badge: "badge 1", levelName: "Starter", levelDescription: "0 - 49.99 Kilometers"),
LeaderBoard(badge: "badge 2", levelName: "Pacer", levelDescription: "50.00 - 249.99 Kilometers"),
LeaderBoard(badge: "badge 3", levelName: "Achiever", levelDescription: "250.00 - 999.9 Kilometers"),
LeaderBoard(badge: "badge 4", levelName: "Champion", levelDescription: "1,000.00 - 4,999.9 Kilometers")
]
    
let leaderboardUsersArray: [LeaderboardUser] = [
    LeaderboardUser(
        name: "Ava Brooks",
        profileImageName: "user_ava",
        kilometers: 15,
        streak: 37,
        points: 436
    ),
    LeaderboardUser(
        name: "John Carter",
        profileImageName: "user_john",
        kilometers: 12,
        streak: 28,
        points: 390
    ),
    LeaderboardUser(
        name: "Emma Lee",
        profileImageName: "user_emma",
        kilometers: 10,
        streak: 22,
        points: 350
    ),
    LeaderboardUser(
        name: "Ryan Smith",
        profileImageName: "user_ryan",
        kilometers: 8,
        streak: 18,
        points: 300
    ),
    LeaderboardUser(
        name: "Sophia Kim",
        profileImageName: "user_sophia",
        kilometers: 6,
        streak: 15,
        points: 270
    )
]

