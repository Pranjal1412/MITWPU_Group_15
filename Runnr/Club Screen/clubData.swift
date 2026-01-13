//
//  clubData.swift
//  Runnr
//
//  Created by SDC-USER on 25/11/25.
//

import Foundation
import UIKit

struct clubData: Codable {
    let image: String
    let clubName: String
    let numberOfMembers: String
    let sport: String
}

struct myClubData {
    let clubProfileImg: String
    let clubName: String
    let numberOfMembers: String
    let sport: String
    let isPublic: Bool
    let clubMotive: String
    let clubDescription: String
}

struct friendsData {
    let profilePhoto: String
    let name: String
    var isFollowing: Bool
}

struct posts {
    let images: String
}


struct LeaderBoard {
    let badge: String
    let levelName: String
    let levelDescription: String
}

var myClubs: [myClubData] = []

let leaderBoardArray: [LeaderBoard] = [
LeaderBoard(badge: "badge 1", levelName: "Starter", levelDescription: "0 - 49.99 Kilometers"),
LeaderBoard(badge: "badge 2", levelName: "Pacer", levelDescription: "50.00 - 249.99 Kilometers"),
LeaderBoard(badge: "badge 3", levelName: "Achiever", levelDescription: "250.00 - 999.9 Kilometers"),
LeaderBoard(badge: "badge 4", levelName: "Champion", levelDescription: "1,000.00 - 4,999.9 Kilometers")
]

var postImagesArray: [posts] = [
    posts(images: "post 1"),
    posts(images: "post 2"),
    posts(images: "post 3"),
    posts(images: "post 4")
]

let clubDataArray: [clubData] = [
    clubData(image: "club1", clubName: "Runnr Club", numberOfMembers: "12k", sport: "Run"),
    clubData(image: "club2", clubName: "Happy Trails", numberOfMembers: "11.2k", sport: "Hiking"),
    clubData(image: "club3", clubName: "Running Global", numberOfMembers: "9.7k", sport: "Run"),
    clubData(image: "club4", clubName: "Fast Wheels", numberOfMembers: "1.5k", sport: "Hiking"),
    clubData(image: "club1", clubName: "Runnr Club", numberOfMembers: "12k", sport: "Run"),
    clubData(image: "club2", clubName: "Happy Trails", numberOfMembers: "11.2k", sport: "Hiking"),
]
    
var friendsDataArray: [friendsData] = [
    friendsData(profilePhoto: "user1", name: "Dave Johnson", isFollowing: false),
    friendsData(profilePhoto: "user2", name: "Mark Brown", isFollowing: true),
    friendsData(profilePhoto: "user3", name: "Sophia Lee", isFollowing: false),
    friendsData(profilePhoto: "user4", name: "Liam Carter", isFollowing: false)
]

enum LeaderboardMode {
    case kilometer
    case streak
    case points
}

struct LeaderboardUser {
    let name: String
    let profileImageName: String   // image asset name
    let kilometers: Int
    let streak: Int
    let points: Int
}

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

struct ClubActivity {
    let image : UIImage?
    let title : String
}

let clubActivityOptions : [ClubActivity] = [ClubActivity(image: UIImage(systemName: "figure.run"), title: "Running"),
                                            ClubActivity(image: UIImage(systemName: "figure.hiking"), title: "Hiking"),
                                            ClubActivity(image: UIImage(systemName: "figure.walk"), title: "Walking"),
                                            ClubActivity(image: UIImage(systemName: "figure.highintensity.intervaltraining"), title: "Marathons")]
