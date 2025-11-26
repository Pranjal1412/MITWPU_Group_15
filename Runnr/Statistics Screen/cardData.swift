//
//  cardData.swift
//  Runnr
//
//  Created by SDC-USER on 19/11/25.
//

import Foundation
struct CardData {
    let number: String
    let units: String
    let title: String
    let trend: String
    let trendChevron: String
}
var cardDataArray: [CardData] = [
    CardData(number: "7.2", units: "Km", title: "Distance Covered",
             trend: "1.2 km more than last week", trendChevron: "chevron.up.2"),

    CardData(number: "528", units: "Kcal", title: "Calories Burnt",
             trend: "50 kcal higher", trendChevron: "chevron.down.2"),

    CardData(number: "10.5", units: "k", title: "Steps Covered",
             trend: "1200 more less", trendChevron: "chevron.up.2"),

    CardData(number: "7:90", units: "mins/km", title: "Average Pace",
             trend: "2 minutes slower", trendChevron: "chevron.down.2")
]

