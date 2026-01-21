//
//  ModelFile.swift
//  Runnr
//
//  Created by Pranjal Shinde on 03/01/26.
//

import UIKit

let runnrCategories: [UserCategory] = [
    UserCategory(name: "Starter", goal: 50, badge: "badge 1"),
    UserCategory(name: "Pacer", goal: 250, badge: "badge 2"),
    UserCategory(name: "Achiever", goal: 600, badge: "badge 3"),
    UserCategory(name: "Champions", goal: 1000, badge: "badge 4")]


struct Settings {
    let symbol: UIImage?
    let title: String
}

let settingsArray : [Int : [Settings]] = [ 0 : [Settings(symbol: UIImage(systemName: "person.circle"), title: "About You"),
                                                Settings(symbol: UIImage(systemName: "dot.radiowaves.left.and.right"), title: "Connect a Device")],
                                           1 : [Settings(symbol: UIImage(systemName: "checkmark.shield"), title: "App Permission"),
                                                Settings(symbol: UIImage(systemName: "lock.shield"), title: "Privacy Controls"),
                                                Settings(symbol: UIImage(systemName: "bell.circle"), title: "Notification Settings")],
                                           2 : [Settings(symbol: UIImage(systemName: "character.bubble"), title: "Language")],
                                           3 : [Settings(symbol: UIImage(systemName: "door.left.hand.open"), title: "Logout"),
                                                Settings(symbol: UIImage(systemName: "trash"), title: "Delete Account")]]
