//
//  cardData.swift
//  Runnr
//
//  Created by SDC-USER on 18/11/25.
//

import Foundation

struct cardData {
    var number: String
    var units: String
    var trendChevron: String
    var trend: String
    var title: String
}
 
let cardDataArray: [cardData] = [
    cardData(number: "7.2", units: "km", trendChevron: "chevron.up", trend: "1.2km more than last run", title: "Distance Covered"),
    cardData(number: "116", units: "kcal", trendChevron: "chevron.down", trend: "12 kcal burnt less than last run", title: "Calories Burnt"),
    cardData(number: "10.5", units: "k", trendChevron: "chevron.up", trend: "1200 steps more than last run", title: "Steps Covered"),
    cardData(number: "7:90", units: "/km", trendChevron: "chevron.down", trend: "2 /km less than last run", title: "Average Pace")
]
