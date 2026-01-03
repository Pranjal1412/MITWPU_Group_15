//
//  ModelFile.swift
//  Runnr
//
//  Created by Pranjal Shinde on 03/01/26.
//

struct Category {
    let name : String
    let goal : Int
    let badge : String
}

let runnrCategories: [Category] = [
    Category(name: "Starter", goal: 50, badge: "badge 1"),
    Category(name: "Pacer", goal: 250, badge: "badge 2"),
    Category(name: "Achiever", goal: 600, badge: "badge 3"),
    Category(name: "Champions", goal: 1000, badge: "badge 4")]
