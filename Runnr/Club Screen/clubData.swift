//
//  clubData.swift
//  Runnr
//
//  Created by SDC-USER on 25/11/25.
//

import Foundation

struct clubData: Codable {
    let image: String
    let clubName: String
    let numberOfMembers: String
    let sport: String
}

struct friendsData {
    let profilePhoto: String
    let name: String
    let followStatus: String
}

struct posts {
    let images: String
}


struct LeaderBoard {
    let badge: String
    let levelName: String
    let levelDescription: String
}



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
        friendsData(profilePhoto: "user1",
                    name: "Dave Johnson",
                    followStatus: "Follow"),
        friendsData(profilePhoto: "user2",
                    name: "Mark Brown",
                    followStatus: "Following"),
        friendsData(profilePhoto: "user3",
                    name: "Sophia Lee",
                    followStatus: "Follow"),
        friendsData(profilePhoto: "user4",
                    name: "Liam Carter",
                    followStatus: "Follow")
    ]

