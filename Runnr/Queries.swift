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
    
    let resizedImage = resizeImageIfNeeded(image, maxDimension: 500)
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
        print("Activty was not inserted")
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
    
    let resizedImage = resizeImageIfNeeded(image, maxDimension: 500)
    if let imageData = resizedImage.jpegData(compressionQuality: 0.8) {
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

func insertNewClubData(newClub: Club) async {
    do {
        // Because of the trigger, this ONE insert updates TWO tables
        try await SupabaseManager.shared.client
            .from("Club")
            .insert(newClub)
            .execute()
        
        print("Club created and ownership assigned automatically!")
    } catch {
        print("Error creating club: \(error)")
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




