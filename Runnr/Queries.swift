//
//  Queries.swift
//  Runnr
//
//  Created by Pranjal Shinde on 01/02/26.
//

import Foundation
import Supabase

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

func uploadImageFetchURL(_ filepath: String, _ image: Data) async -> String? {
    do {
        try await SupabaseManager.shared.client.storage
            .from("IMAGES")
            .upload(filepath, data: image, options: FileOptions(contentType: "image/jpeg", upsert: true))
        
        let publicURL = try? SupabaseManager.shared.client.storage
            .from("IMAGES")
            .getPublicURL(path: filepath)
        
        return publicURL!.absoluteString
    }
    catch {
        print("Upload Failed")
        return nil
    }
}

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

func insertRouteCoordinates(_ coordinates: [ActivityRouteCoordinates]) async {

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
func updateUserActivity(userID : UUID, activityID : UUID, newActivity: UserActivity) async {
    
    do {
        try await SupabaseManager.shared.client
            .from("UserActivity")
            .update(newActivity)
            .eq("userID", value: userID)
            .eq("activityID", value: activityID)
            .execute()

    } catch {
        print("Updation failed: \(error)")
    }
}

func fetchActivityMapImageURL(activityID: UUID , userID : UUID) async throws -> String? {

    let response: String = try await SupabaseManager.shared.client
        .from("UserActivity")
        .select("mapImageURL")
        .eq("activityID", value: activityID)
        .eq("userID", value: userID)
        .single()
        .execute()
        .value

    return response
}
