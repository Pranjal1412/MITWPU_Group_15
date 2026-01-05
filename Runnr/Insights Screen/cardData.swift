//
//  cardData.swift
//  Runnr
//
//  Created by SDC-USER on 19/11/25.
//

import Foundation
struct CardData {
    var number: String
    let unit : String
    let title: String
    var trend: String
    var trendChevron: String
}
var cardDataArray: [CardData] = [
    CardData(number: "7.2", unit: "Km", title: "Distance Covered",
             trend: "1.2 km more than last week", trendChevron: "chevron.up.2"),

    CardData(number: "528", unit: "Kcal", title: "Calories Burnt",
             trend: "50 kcal lower", trendChevron: "chevron.down.2"),

    CardData(number: "10.5", unit: "k", title: "Steps Covered",
             trend: "1200 more", trendChevron: "chevron.up.2"),

    CardData(number: "7:90", unit: "min/km", title: "Average Pace",
             trend: "2 minutes slower", trendChevron: "chevron.down.2")
]
