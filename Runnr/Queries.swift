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
        let images = await fetchActivityImages(activityID)
        for image in images {
            await deleteImageFromStorage(imageURL: image.photoURL)
        }

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

func fetchAllMyActivities(userProfile: UserProfile) async -> [ActivityDetails] {
    do {
        
        let response: [UserActivity] = try await SupabaseManager.shared.client
            .from("UserActivity")
            .select()
            .eq("userID", value: userProfile.userID)
            .order("activityStartTime", ascending: false)
            .execute()
            .value
        
        let result = response.map { activity in
            ActivityDetails(
                userDetails: userProfile,
                activity: activity
            )
        }
        
        return result
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

func saveActivityImages(activityID: UUID, with image: UIImage, seq: Int) async -> String? {
    
    let resizedImage = resizeImageIfNeeded(image, maxDimension: 700)
    if let imageData = resizedImage.jpegData(compressionQuality: 0.9) {
        let filePath = "ActivityImages/\(activityID)_\(Int(Date().timeIntervalSince1970))_\(seq).jpg"
        
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

func insertActivityImages(_ images: [ActivityPhotos]) async {

    do {
        guard !images.isEmpty else { return }
        try await SupabaseManager.shared.client
            .from("ActivityPhotos")
            .insert(images)
            .execute()

    } catch {
        print("Insertion failed: \(error)")
    }
}

func fetchActivityImages(_ activityID: UUID) async -> [ActivityPhotos] {
    
    do {
        let images: [ActivityPhotos] = try await SupabaseManager.shared.client
          .from("ActivityPhotos")
          .select()
          .eq("activityID", value: activityID)
          .order("sequence", ascending: true)
          .execute()
          .value

        return images
        
    } catch {
        print("Failed to fetch route coordinates:", error)
        return []
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
            .select()
            .single()
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

func removeClubMember(userID: UUID, clubID: UUID) async {
    do {
        try await SupabaseManager.shared.client
            .from("ClubMemberRole")
            .delete()
            .eq("userID", value: userID)
            .eq("clubID", value: clubID)
            .execute()
        print("Member removed from club successfully!")
    } catch {
        print("Error removing member from club: \(error)")
    }
}

func deleteClub(clubID: UUID) async {
    do {
        // Delete post images from storage before CASCADE removes the rows
        let posts: [ClubPost] = try await SupabaseManager.shared.client
            .from("ClubPost")
            .select()
            .eq("clubID", value: clubID)
            .execute()
            .value
        
        for post in posts {
            if let imageURL = post.postImageURL, !imageURL.isEmpty {
                await deleteImageFromStorage(imageURL: imageURL)
            }
        }
        
        // Delete club profile and banner images from storage
        let club: Club = try await SupabaseManager.shared.client
            .from("Club")
            .select()
            .eq("clubID", value: clubID)
            .single()
            .execute()
            .value
        
        if let profileURL = club.clubProfileImageURL, !profileURL.isEmpty {
            await deleteImageFromStorage(imageURL: profileURL)
        }
        if let bannerURL = club.clubBannerImageURL, !bannerURL.isEmpty {
            await deleteImageFromStorage(imageURL: bannerURL)
        }
        
        // Now delete the club — CASCADE handles ClubMemberRole and ClubPost rows
        try await SupabaseManager.shared.client
            .from("Club")
            .delete()
            .eq("clubID", value: clubID)
            .execute()

        print("Club deleted successfully!")
    } catch {
        print("Error deleting club: \(error)")
    }
}

func saveClubProfileImage(clubID: UUID, with image: UIImage) async -> String? {
    
    let resizedImage = resizeImageIfNeeded(image, maxDimension: 400)
    
    if let imageData = resizedImage.jpegData(compressionQuality: 0.8) {
        let filePath = "clubImages/clubProfile/\(clubID)_\(Int(Date().timeIntervalSince1970)).jpg"
        
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

func saveClubBannerImage(clubID: UUID, with image: UIImage) async -> String? {
    
    let resizedImage = resizeImageIfNeeded(image, maxDimension: 400)
    
    if let imageData = resizedImage.jpegData(compressionQuality: 0.8) {
        let filePath = "clubImages/clubBanner/\(clubID)_\(Int(Date().timeIntervalSince1970)).jpg"
        
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

func insertNewClubEvent(event: ClubEvents) async {
    do {
        try await SupabaseManager.shared.client
            .from("ScheduledClubEvents")
            .insert(event)
            .execute()
        
        print("Insert Successfull!")
    }
    catch {
        print("Error creating club: \(error)")
    }
}

func fetchClubEvents(clubID: UUID) async -> [ClubEvents]? {
    do {
        let allEvents: [ClubEvents] = try await SupabaseManager.shared.client
            .from("ScheduledClubEvents")
            .select()
            .eq("clubID", value: clubID)
            .execute()
            .value
        
        print("Fetch Successfull!")
        return allEvents
    }
    catch {
        print("Error creating club: \(error)")
        return nil
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

func updateGamePlayerTwo(gameID: UUID, playerTwoID: UUID) async {
    do {
        let response = try await SupabaseManager.shared.client
            .from("TerritoryGame")
            .update(["playerTwoID": playerTwoID])
            .eq("gameID", value: gameID)
            .select()
            .execute()
        

        print("UPDATE RESPONSE:", response)
    } catch {
        print("updateGamePlayerTwo failed: \(error)")
    }
}

func fetchActiveGameForUser(userID: UUID) async -> TerritoryGame? {
    do {
        let games: [TerritoryGame] = try await SupabaseManager.shared.client
            .from("TerritoryGame")
            .select()
            .or("playerOneID.eq.\(userID),playerTwoID.eq.\(userID)")
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
    guard !tiles.isEmpty else { return }
    do {
        print("Attempting to upsert to Supabase: \(tiles)")
        try await SupabaseManager.shared.client
            .from("TerritoryHexTile")
            .upsert(tiles)
            .execute()
        print("Successfully upserted tiles to Supabase")
    } catch {
        print("Tile batch upsert failed with primary error: \(error)")
        // Fallback for cases where unique constraint definition mismatches
        for tile in tiles {
            do {
                try await SupabaseManager.shared.client
                    .from("TerritoryHexTile")
                    .delete()
                    .eq("tileID", value: tile.tileID)
                    .eq("gameID", value: tile.gameID)
                    .execute()
                    
                try await SupabaseManager.shared.client
                    .from("TerritoryHexTile")
                    .insert(tile)
                    .execute()
                print("Fallback insert succeeded for \(tile.tileID)")
            } catch let fallbackError {
                print("Tile fallback insert failed for \(tile.tileID) - GameID: \(tile.gameID) - OwnerID: \(String(describing: tile.ownerID)). Error: \(fallbackError)")
            }
        }
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
        
        // converting the solochallenges array into a dictionary of [UUID : SoloChallenges]
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

//MARK: - Friends Follow/Unfollow

// Returns UserProfile rows for all users the current user has NOT yet followed (excluding themselves).
func fetchUnfollowedUsers(currentUserID: UUID) async -> [UserProfile] {
    do {
        // 1. Get all IDs the current user already follows
        let followed: [FollowerAndFollowing] = try await SupabaseManager.shared.client
            .from("FollowerAndFollowing")
            .select()
            .eq("FollowerID", value: currentUserID) //users ID
            .execute()
            .value

        
        let followedIDs = followed.map { $0.FollowingID } // get IDs of friends user follows

        // 2. Fetch all user profiles
        if followedIDs.isEmpty {
            let allUsers: [UserProfile] = try await SupabaseManager.shared.client
                .from("UserProfile")
                .select()
                .neq("userID", value: currentUserID)
                .execute()
                .value
            
            return allUsers
        }

        // Convert UUIDs into SQL array string
        var idsToExclude = followedIDs
        idsToExclude.append(currentUserID)
        let formattedIDs = idsToExclude.map { "\"\($0.uuidString)\"" }.joined(separator: ",")

        let allUsers: [UserProfile] = try await SupabaseManager.shared.client
            .from("UserProfile")
            .select("*")
            .not("userID", operator: .in, value: "(\(formattedIDs))")
            .execute()
            .value
        
        return allUsers
        
    } catch {
        print("fetchUnfollowedUsers failed: \(error)")
        return []
    }
}

func fetchFollowedUsersAtivities(currentUserID: UUID) async -> [ActivityDetails] {
    do {
        // 1. Get IDs the user follows
        let followed: [FollowerAndFollowing] = try await SupabaseManager.shared.client
            .from("FollowerAndFollowing")
            .select()
            .eq("FollowerID", value: currentUserID)
            .execute()
            .value

        let followedIDs = followed.map { $0.FollowingID }.filter { $0 != currentUserID }
  
        let activities: [ActivityDetails] = try await SupabaseManager.shared.client
            .rpc("get_friends_latest_activity", params: ["friend_ids": followedIDs])
            .execute()
            .value
        
        return activities

    } catch {
        print("fetchFollowedUsers failed: \(error)")
        return []
    }
}

func fetchFollowersList(userID: UUID) async -> [UserProfile] {
    do {
        // 1. Get IDs of users who follow the given user
        let followers: [FollowerAndFollowing] = try await SupabaseManager.shared.client
            .from("FollowerAndFollowing")
            .select()
            .eq("FollowingID", value: userID)
            .execute()
            .value
            
        let followerIDs = followers.map { $0.FollowerID }
        
        if followerIDs.isEmpty {
            return []
        }
                
        // 2. Fetch their user profiles
        let users: [UserProfile] = try await SupabaseManager.shared.client
            .from("UserProfile")
            .select("*")
            .in("userID", values: followerIDs)
            .execute()
            .value
            
        return users
        
    } catch {
        print("fetchFollowersList failed: \(error)")
        return []
    }
}

func fetchFollowingList(userID: UUID) async -> [UserProfile] {
    do {
        // 1. Get IDs of users whom the given user follows
        let following: [FollowerAndFollowing] = try await SupabaseManager.shared.client
            .from("FollowerAndFollowing")
            .select()
            .eq("FollowerID", value: userID)
            .execute()
            .value
            
        let followingIDs = following.map { $0.FollowingID }
        
        if followingIDs.isEmpty {
            return []
        }
            
        // 2. Fetch their user profiles
        let users: [UserProfile] = try await SupabaseManager.shared.client
            .from("UserProfile")
            .select("*")
            .in("userID", values: followingIDs)
            .execute()
            .value
            
        return users
        
    } catch {
        print("fetchFollowingList failed: \(error)")
        return []
    }
}

// Inserts a follow relationship into the FollowerAndFollowing table.
func insertFollowedUser(followerID: UUID, followingID: UUID) async {
    do {
        let record = FollowerAndFollowing(FollowerID: followerID, FollowingID: followingID)
        try await SupabaseManager.shared.client
            .from("FollowerAndFollowing")
            .insert(record)
            .execute()
    } catch {
        print("followUser failed: \(error)")
    }
}

//MARK: - Club Post

func insertNewClubPost(postDetails: ClubPost) async -> ClubPost? {
    do {
        let newPost: ClubPost = try await SupabaseManager.shared.client
            .from("ClubPost")
            .insert(postDetails)
            .select()
            .single()
            .execute()
            .value
        
        return newPost
    }
    catch {
        print("Error inserting new club post: \(error)")
        return nil
    }
}

func updateClubPost(postDetails: ClubPost) async {
    do {
        try await SupabaseManager.shared.client
            .from("ClubPost")
            .update(postDetails)
            .eq("postID", value: postDetails.postID)
            .execute()
        
    }
    catch {
        print("Error inserting new club post: \(error)")
    }
}

func fetchAllClubPosts(for clubID: UUID) async -> [ClubPostDetail]? {
    do {
        let allPosts: [ClubPost] = try await SupabaseManager.shared.client
            .from("ClubPost")
            .select()
            .eq("clubID", value: clubID)
            .order("createdTimestamp")
            .execute()
            .value
        
        let postOwnerIDs = allPosts.map { $0.postOwner }
        
        let ownerDetails: [UserProfile] = try await SupabaseManager.shared.client
            .from("UserProfile")
            .select("*")
            .in("userID", values: postOwnerIDs)
            .execute()
            .value
        
        // Create dictionary for quick lookup
        let ownerDict = Dictionary(uniqueKeysWithValues: ownerDetails.map { ($0.userID, $0) })
        
        // Map into ClubPostDetail
        let result: [ClubPostDetail] = allPosts.compactMap { post in
            
            guard let owner = ownerDict[post.postOwner] else { return nil }
            
            return ClubPostDetail(postOwner: owner, post: post)
        }

        return result
    }
    catch {
        print("Error fetching club posts: \(error)")
        return nil
    }
}

func deleteClubPost(postID : UUID, postImageURL : String) async {
    do {
        
        try await SupabaseManager.shared.client
            .from("ClubPost")
            .delete()
            .eq("postID", value: postID)
            .execute()
        
        await deleteImageFromStorage(imageURL: postImageURL)
    }
    catch {
        print("Deletion failed: \(error)")
    }
}


func saveClubPostImage(postID: UUID, with image: UIImage) async -> String? {
    
    let resizedImage = resizeImageIfNeeded(image, maxDimension: 400)
    
    if let imageData = resizedImage.jpegData(compressionQuality: 0.8) {
        let filePath = "clubImages/clubPost/\(postID)_\(Int(Date().timeIntervalSince1970)).jpg"
        
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

// MARK: - Battle Invite Notifications

func insertBattleInviteNotification(_ notification: BattleInviteNotification) async {
    do {
        try await SupabaseManager.shared.client
            .from("BattleInviteNotification")
            .insert(notification)
            .execute()
        
        print("Battle invite notification inserted successfully")
    } catch {
        print("Insert notification failed: \(error)")
    }
}

func fetchBattleInviteNotifications(for receiverID: UUID) async -> [BattleInviteNotification] {
    do {
        let notifications: [BattleInviteNotification] = try await SupabaseManager.shared.client
            .from("BattleInviteNotification")
            .select()
            .eq("receiverID", value: receiverID)
            .order("createdAt", ascending: false)
            .execute()
            .value
        return notifications
    } catch {
        print("Fetch notifications failed: \(error)")
        return []
    }
}
func insertScheduledClubEvent(_ event: ClubEvents) async {
    do {
        try await SupabaseManager.shared.client
            .from("ScheduledClubEvents")
            .insert(event)
            .execute()
    } catch {
        print("Failed to insert scheduled club event: \(error)")
    }
}


