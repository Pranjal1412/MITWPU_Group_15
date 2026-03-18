//
//  Queries1.swift
//  Runnr
//
//  Created by Pranjal Shinde on 18/03/26.
//

import Foundation
import Supabase
import UIKit

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

func fetchAllClubPosts(for clubID: UUID) async -> [ClubPost]? {
    do {
        let allPosts: [ClubPost] = try await SupabaseManager.shared.client
            .from("ClubPost")
            .select()
            .eq("clubID", value: clubID)
            .order("createdTimestamp")
            .execute()
            .value
        
        return allPosts
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
