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
