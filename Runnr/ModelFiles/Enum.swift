//
//  Enum.swift
//  Runnr
//
//  Created by SDC-USER on 29/01/26.
//


enum Gender: String, Codable {
    case male, female, other
}

enum ActivityType: String, Codable {
    case running = "Running"
    case walking = "Walking"
    case marathon = "Marathon"
    case hiking = "Hiking"
}

enum DistanceUnit: String, Codable {
    case kilometers = "km"
    case miles = "mi"
}

enum PaceUnit: String, Codable {
    case minPerKm = "min/km"
    case minPerMile = "min/mi"
}

enum RunnrCategory: String, Codable {
    case Starter = "Starter"
    case Pacer = "Pacer"
    case Achiever = "Achiever"
    case Champion = "Champion"
}

enum ClubRoleType : String, Codable{
    case owner = "Owner"
    case member = "Member"
}
