//
//  clubData.swift
//  Runnr
//
//  Created by SDC-USER on 25/11/25.
//

import Foundation
import UIKit

struct ExploreClubData {
    let clubProfileImg: UIImage?
    let clubName: String
    let numberOfMembers: String
    let sport: String
    let clubMotive: String
    let clubDescription: String
    let postImages = [UIImage(named: "post 1"), UIImage(named: "post 2"), UIImage(named: "post 3"), UIImage(named: "post 4")]
}

struct MyClubData {
    let clubProfileImg: UIImage
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

struct ClubActivity {
    let image : UIImage?
    let title : String
}

var myClubs: [MyClubData] = []

let leaderBoardArray: [LeaderBoard] = [
LeaderBoard(badge: "badge 1", levelName: "Starter", levelDescription: "0 - 49.99 Kilometers"),
LeaderBoard(badge: "badge 2", levelName: "Pacer", levelDescription: "50.00 - 249.99 Kilometers"),
LeaderBoard(badge: "badge 3", levelName: "Achiever", levelDescription: "250.00 - 999.9 Kilometers"),
LeaderBoard(badge: "badge 4", levelName: "Champion", levelDescription: "1,000.00 - 4,999.9 Kilometers")
]

let clubDataArray: [ExploreClubData] = [
    ExploreClubData(
        clubProfileImg: UIImage(named: "club1"),
        clubName: "Runnr Club",
        numberOfMembers: "12k",
        sport: "Run",
        clubMotive: "Run together. Grow stronger.",
        clubDescription: "A community of passionate runners focused on consistency, endurance, and pushing personal limits."
    ),
    ExploreClubData(
        clubProfileImg: UIImage(named: "club2"),
        clubName: "Happy Trails",
        numberOfMembers: "11.2k",
        sport: "Hiking",
        clubMotive: "Explore more, worry less.",
        clubDescription: "Weekend hikers and nature lovers who enjoy discovering scenic trails and peaceful escapes."
    ),
    ExploreClubData(
        clubProfileImg: UIImage(named: "club3"),
        clubName: "Running Global",
        numberOfMembers: "9.7k",
        sport: "Run",
        clubMotive: "Miles without borders.",
        clubDescription: "An international running club connecting athletes worldwide through virtual and local runs."
    ),
    ExploreClubData(
        clubProfileImg: UIImage(named: "club4"),
        clubName: "Fast Wheels",
        numberOfMembers: "1.5k",
        sport: "Hiking",
        clubMotive: "Adventure at full speed.",
        clubDescription: "For thrill-seekers who love fast-paced hikes, elevation challenges, and rugged terrains."
    ),
    ExploreClubData(
        clubProfileImg: UIImage(named: "club1"),
        clubName: "Runnr Club",
        numberOfMembers: "12k",
        sport: "Run",
        clubMotive: "Run together. Grow stronger.",
        clubDescription: "Daily runs, training plans, and motivation for runners of all experience levels."
    ),
    ExploreClubData(
        clubProfileImg: UIImage(named: "club2"),
        clubName: "Happy Trails",
        numberOfMembers: "11.2k",
        sport: "Hiking",
        clubMotive: "Nature is the best therapy.",
        clubDescription: "A friendly hiking group focused on mental wellness, exploration, and community bonding."
    )
]
    
var friendsDataArray: [friendsData] = [
    friendsData(profilePhoto: "user1", name: "Dave Johnson", isFollowing: false),
    friendsData(profilePhoto: "user2", name: "Mark Brown", isFollowing: true),
    friendsData(profilePhoto: "user3", name: "Sophia Lee", isFollowing: false),
    friendsData(profilePhoto: "user4", name: "Liam Carter", isFollowing: false)
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

let clubActivityOptions : [ClubActivity] = [ClubActivity(image: UIImage(systemName: "figure.run"), title: "Running"),
                                            ClubActivity(image: UIImage(systemName: "figure.hiking"), title: "Hiking"),
                                            ClubActivity(image: UIImage(systemName: "figure.walk"), title: "Walking"),
                                            ClubActivity(image: UIImage(systemName: "figure.highintensity.intervaltraining"), title: "Marathons")]

let clubDescriptions: [String] = ["Just for fun!", "Competitive Play", "Fitness", "Charity"]
