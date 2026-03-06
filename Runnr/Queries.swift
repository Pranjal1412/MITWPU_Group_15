//
//  Queries.swift
//  Runnr
//
//  Created by Pranjal Shinde on 01/02/26.
//

import Foundation
import Supabase
import UIKit

// MARK: - User Profile Queries
func insertUserProfile(_ profile: UserProfile) async {
    do {
        try await SupabaseManager.shared.client
            .from("UserProfile")
            .insert(profile)
            .execute()

    } catch {
        print("Insertion failed: \(error)")
    }
}

func insertUserStats(_ stats: UserStats) async {
    do {
        try await SupabaseManager.shared.client
            .from("UserStats")
            .insert(stats)
            .execute()
    }
    catch {
        print("Insertion failed: \(error)")
    }
}

func fetchUserProfile(userId: UUID) async -> UserProfile? {
    do {
        let profile: UserProfile? = try await SupabaseManager.shared.client
            .from("UserProfile")
            .select()
            .eq("userID", value: userId)
            .single()
            .execute()
            .value
        return profile
    } catch {
        print("User does not have an account")
        return nil
    }
}

func fetchUserStats(userId: UUID) async -> UserStats? {
    do {
        let stats: UserStats? = try await SupabaseManager.shared.client
            .from("UserStats")
            .select()
            .eq("userID", value: userId)
            .single()
            .execute()
            .value
        return stats
    }
    catch {
        print("User Stats fetch failed \(error)")
        return nil
    }
}

func updateUserProfile(userID: UUID, newProfile: UserProfile) async {
    do {
        try await SupabaseManager.shared.client
            .from("UserProfile")
            .update(newProfile)
            .eq("userID", value: userID)
            .execute()
    }
    catch {
        print("Updation failed: \(error)")
    }
}

func saveProfileImage(userID: UUID, with image: UIImage) async -> String? {
    
    let resizedImage = resizeImageIfNeeded(image, maxDimension: 400)
    
    if let imageData = resizedImage.jpegData(compressionQuality: 0.8) {
        let filePath = "profiles/\(userID)_\(Int(Date().timeIntervalSince1970)).jpg"
        
        if let url = await saveAndFetchImageURL(with: filePath, imageData: imageData) {
            return url
            
        } else {
            print("Upload failed")
            return nil
        }
    }
    else {
        print("Image compression failed")
        return nil
    }
}

func updateUserStats(userID: UUID, newStats: UserStats) async {
    do {
        try await SupabaseManager.shared.client
            .from("UserStats")
            .update(newStats)
            .eq("userID", value: userID)
            .execute()
    }
    catch {
        print("Updation failed: \(error)")
    }
}

// MARK: - User Activity Queries
func insertActivity(_ activity: UserActivity) async -> UserActivity? {
    do {
        let insertedActivity: UserActivity = try await SupabaseManager.shared.client
            .from("UserActivity")
            .insert(activity)
            .select()
            .single()
            .execute()
            .value

        return insertedActivity
    }
    catch {
        print("Activty was not inserted \(error)")
        return nil
    }
}

func updateUserActivity(newActivity: UserActivity) async {
    
    do {
        try await SupabaseManager.shared.client
            .from("UserActivity")
            .update(newActivity)
            .eq("activityID", value: newActivity.activityID)
            .execute()

    } catch {
        print("Updation failed: \(error)")
    }
}

func deleteUserActivity(activityID : UUID, mapImageURL : String) async {
    do {
        
        try await SupabaseManager.shared.client
            .from("UserActivity")
            .delete()
            .eq("activityID", value: activityID)
            .execute()
        
        await deleteImageFromStorage(imageURL: mapImageURL)
    }
    catch {
        print("Deletion failed: \(error)")
    }
}

func fetchAllMyActivities(userID : UUID) async -> [UserActivity] {
    do {
        
        let response: [UserActivity] = try await SupabaseManager.shared.client
            .from("UserActivity")
            .select()
            .eq("userID", value: userID)
            .order("activityStartTime", ascending: false)
            .execute()
            .value
        
        return response
    }
    catch {
        print("Data not found")
         return []
    }
}

func saveMapImage(activityID: UUID, with image: UIImage) async -> String? {
    
    let resizedImage = resizeImageIfNeeded(image, maxDimension: 700)
    if let imageData = resizedImage.jpegData(compressionQuality: 0.9) {
        let filePath = "activityMapImages/\(activityID)_\(Int(Date().timeIntervalSince1970)).jpg"
        
        if let url = await saveAndFetchImageURL(with: filePath, imageData: imageData) {
            return url
            
        } else {
            print("Upload failed")
            return nil
        }
    }
    else {
        print("Image compression failed")
        return nil
    }
}

// MARK: - User Activity Route Coordinates
func insertActivityRouteCoordinates(_ coordinates: [ActivityRouteCoordinates]) async {

    do {
        guard !coordinates.isEmpty else { return }
        try await SupabaseManager.shared.client
            .from("ActivityRouteCoordinates")
            .insert(coordinates)
            .execute()

    } catch {
        print("Insertion failed: \(error)")
    }
}

func fetchActivityRouteCoordinates(_ activityID: UUID) async -> [ActivityRouteCoordinates] {
    
    do {
        let coordinates: [ActivityRouteCoordinates] = try await SupabaseManager.shared.client
          .from("ActivityRouteCoordinates")
          .select()
          .eq("activityID", value: activityID)
          .order("sequence", ascending: true)
          .execute()
          .value

        return coordinates
    } catch {
        print("Failed to fetch route coordinates:", error)
        return []
    }
    
}

// MARK: - User Activity Pace Graph Activity
func insertActivityPaceGraphData(_ graphData: [ActivityPaceGraphData]) async {

    do {
        guard !graphData.isEmpty else { return }
        try await SupabaseManager.shared.client
            .from("ActivityPaceGraphData")
            .insert(graphData)
            .execute()

    } catch {
        print("Insertion failed: \(error)")
    }
}

func fetchActivityPaceGraphData(_ activityID: UUID) async -> [ActivityPaceGraphData] {
    
    do {
        let graphData: [ActivityPaceGraphData] = try await SupabaseManager.shared.client
            .from("ActivityPaceGraphData")
            .select()
            .eq("activityID", value: activityID)
            .order("distanceValue", ascending: true)
            .execute()
            .value
        
        return graphData
    }
    catch {
        print("Failed to fetch route coordinates:", error)
        return []
    }
}

// MARK: - Image Uploading

// Add the image to supabase Storage
func saveAndFetchImageURL(with filepath: String, imageData: Data) async -> String? {
    do {
        try await SupabaseManager.shared.client.storage
            .from("publicMedia")
            .upload(filepath, data: imageData, options: FileOptions(contentType: "image/jpeg", upsert: true))
        
        let publicURL = try SupabaseManager.shared.client.storage
            .from("publicMedia")
            .getPublicURL(path: filepath)
        
        return publicURL.absoluteString

    }
    catch {
        print("Upload Failed: \(error)")
        return nil
    }
}

func deleteImageFromStorage(imageURL: String) async {
    do {
        guard let url = URL(string: imageURL) else { return }

        // removes the the domain and just return the remaining part
        let fullPath = url.path
        print(fullPath)
        // replacing the remaining part with empty string
        let path = fullPath.replacingOccurrences(of: "/storage/v1/object/public/publicMedia/", with: "")
        print(path)
        
        try await SupabaseManager.shared.client.storage
            .from("publicMedia")
            .remove(paths: [path])
    }
    catch {
        print("Deletion failed: \(error)")
    }
}
// MARK: - Club Data

func fetchExploreClubData(userID: UUID) async -> [Club] {

    do {
        let joinedClubs: [ClubMemberRole] = try await SupabaseManager.shared.client
            .from("ClubMemberRole")
            .select()
            .eq("userID", value: userID)
            .execute()
            .value
        
        let clubIDs = joinedClubs.map { $0.clubID }
        
        // If user has no clubs, return all clubs
        if clubIDs.isEmpty {
            return try await SupabaseManager.shared.client
                .from("Club")
                .select("*")
                .execute()
                .value
        }

        // Convert UUIDs into SQL array string
        let formattedIDs = clubIDs.map { "\"\($0!.uuidString)\"" }.joined(separator: ",")

        let clubs: [Club] = try await SupabaseManager.shared.client
            .from("Club")
            .select("*")
            .not("clubID", operator: .in, value: "(\(formattedIDs))")
            .execute()
            .value
        
        return clubs
    }
    catch {
        print("Failed to fetch \(error)")
        return []
    }
}

func fetchMyClubsWithRoles(userID: UUID) async -> [ClubRoleAndData] {
    do {
        let response: [ClubRoleAndData] = try await SupabaseManager.shared.client
            .from("ClubMemberRole")
            .select("""
                role,
                club:Club (*)
            """)
            .eq("userID", value: userID)
            .execute()
            .value
        
        return response
    } catch {
        print("Error fetching joined data: \(error)")
        return []
    }
}

func insertNewClubData(newClub: Club) async -> Club? {
    do {
        let insertedClub: Club = try await SupabaseManager.shared.client
            .from("Club")
            .insert(newClub)
            .execute()
            .value
        
        print(insertedClub)
        print("Club created and ownership assigned automatically!")
        return insertedClub
        
    } catch {
        print("Error creating club: \(error)")
        return nil
    }
}

func updateClubInfo(clubID: UUID, updatedData: Club) async {
    do {
        try await SupabaseManager.shared.client
            .from("Club")
            .update(updatedData)
            .eq("clubID", value: clubID)
            .execute()
    }
    catch {
        print("Updation failed: \(error)")
    }
}


func insertNewClubMember(newMember: ClubMemberRole) async {
    do {
        try await SupabaseManager.shared.client
            .from("ClubMemberRole")
            .insert(newMember)
            .execute()
        
        print("Insert Successfull!")
    }
    catch {
        print("Error creating club: \(error)")
    }
}

//MARK: - Graph Queries

func fetchSummary(userID: UUID, period: Period, referenceDate: Date) async throws -> [SummaryRow]? {
    
    let parameters : [String: String] = ["user_id": userID.uuidString, "time_period": period.rawValue, "reference_date": "\(referenceDate)"]
    
    do {
        let response: [SummaryRow] = try await SupabaseManager.shared.client
            .rpc("get_user_activity_summary",params: parameters)
            .execute()
            .value
        
        return response
    }
    catch {
        print("Failure fetching summary: \(error)")
        return nil
    }
    
}

//MARK: - Game Settings

func downloadTerritoryFile() async -> URL? {
    do {
        //document url fetched
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //appended fileName to create a full url
        let localURL = documents.appendingPathComponent("Territory.reality")
                
        if FileManager.default.fileExists(atPath: localURL.path) == false {
            // raw data from supabase of the game is downloaded
            let data = try await SupabaseManager.shared.client.storage
                .from("game-assets")
                .download(path: "Territory.reality")
            
            //writes the data to the given path in local URL
            try data.write(to: localURL, options: .atomic)
            
            return localURL
        }
        
        return localURL
        
    } catch {
        print("Download failed:", error)
        return nil
    }
}

func insertNewGame(gameData: TerritoryGame) async -> TerritoryGame? {
    do {
        let insertedGame: TerritoryGame = try await SupabaseManager.shared.client
            .from("TerritoryGame")
            .insert(gameData)
            .select()
            .single()
            .execute()
            .value
                
        return insertedGame

    }
    catch {
        print("Insertion Failed: \(error)")
        return nil
    }
}

func fetchActiveGameForUser(userID: UUID) async -> TerritoryGame? {
    do {
        let games: [TerritoryGame] = try await SupabaseManager.shared.client
            .from("TerritoryGame")
            .select()
            .eq("playerOneID", value: userID)
            .or("isCompleted.is.null,isCompleted.eq.false")
            .limit(1)
            .execute()
            .value
        return games.first
    } catch {
        print("Fetch active game failed: \(error)")
        return nil
    }
}

func fetchGameTileStatus(gameID: UUID) async -> [TerritoryHexTile]? {
    do {
        let tileStatus : [TerritoryHexTile] = try await SupabaseManager.shared.client
            .from("TerritoryHexTile")
            .select()
            .eq("gameID", value: gameID)
            .execute()
            .value
            
        return tileStatus
    }
    catch {
        print("Fetch of game tile status failed: \(error)")
        return nil
    }
}

func upsertGameTiles(_ tiles: [TerritoryHexTile]) async {
    do {
        guard !tiles.isEmpty else { return }
        try await SupabaseManager.shared.client
            .from("TerritoryHexTile")
            .upsert(tiles)
            .execute()
    } catch {
        print("Tile upsert failed: \(error)")
    }
}

//MARK: - Solo Challenges Queries

func getWeeklySoloChallenges(userProfile: UserProfile) async -> [AssignedChallengesProgress]? {

    do {
//        returns current weeks moday's date
        let currentWeek = getCurrentWeekStart()
        // Check existing user challenges
        var assignedChallenges: [AssignedChallenges] = try await SupabaseManager.shared.client
            .from("AssignedSoloChallenges")
            .select()
            .eq("userID", value: userProfile.userID)
            .eq("weekStartDate", value: currentWeek)
            .execute()
            .value

        // If none → fetch random and insert
        if assignedChallenges.isEmpty {

            // get new 3 random challenge
            let newChallenges: [SoloChallenges] = try await SupabaseManager.shared.client
                .rpc("get_random_solo_challenges", params: ["p_user_id": userProfile.userID!.uuidString,"p_difficulty": userProfile.userLevel!.rawValue])
                .execute()
                .value

            // convert it to AssignedChallenges type
            let challengesSelected = newChallenges.map {
                AssignedChallenges(userID: userProfile.userID!, challengeID: $0.challengeID, currentProgress: 0, isCompleted: false, weekStartDate: currentWeek, rewardClaimed: false)
            }

            // insert to AssignedSoloChallenges table which keeps a track of the challenges assigned and progress
            try await SupabaseManager.shared.client
                .from("AssignedSoloChallenges")
                .insert(challengesSelected)
                .execute()

            assignedChallenges = challengesSelected
        }
            
        let challengeIDs = assignedChallenges.map { $0.challengeID }
        
        let soloChallenges: [SoloChallenges] = try await SupabaseManager.shared.client
            .from("SoloChallenges")
            .select()
            .in("challengeID", values: challengeIDs)
            .execute()
            .value
        
        // converting the sollochallenges array into a dictionary of [UUID : SoloChallenges]
        let challengeMap = Dictionary(uniqueKeysWithValues:soloChallenges.map { ($0.challengeID, $0) })

        return assignedChallenges.compactMap { assigned in
            // now based on the challengeID from assigned which is of type AssignedChallenges we get soloChallenge from challengeMap in detail constant
            guard let details = challengeMap[assigned.challengeID] else { return nil }
            return AssignedChallengesProgress(assignedChallenge: assigned,challengeDetails: details)
        }
        
    } catch {
        print("Error fetching weekly challenges: \(error)")
        return nil
    }
}

//func updateChallengeProgress(challengeProgress: AssignedChallenges, userProfile: UserProfile) async {
//    do {
//        try await SupabaseManager.shared.client
//            .from("Club")
//            .update(challengeProgress)
//            .eq("challengeID", value: challengeProgress.challengeID)
//            .eq("userID", value: userProfile.userID)
//            .execute()
//    }
//    catch {
//        print("Updation failed: \(error)")
//    }
//}

func updateAssignedChallengeRewards(challenge: AssignedChallenges) async {
    do {
        try await SupabaseManager.shared.client
            .from ("AssignedSoloChallenges")
            .update(challenge)
            .eq("userID", value: challenge.userID)
            .eq("challengeID", value: challenge.challengeID)
            .execute()
            
    }
    catch {
        print("Updation failed: \(error)")
    }
}
