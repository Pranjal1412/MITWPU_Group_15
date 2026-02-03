//
//  SupabaseManager.swift
//  Runnr
//
//  Created by SDC-USER on 31/01/26.
//

import Supabase
import Foundation
import UIKit

class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        self.client = SupabaseClient(supabaseURL: URL(string: "https://sopdroanstpbthnxpvxr.supabase.co")!, supabaseKey: "sb_publishable_a-5EbK84aAtodb0M3SJR7w_ZuCmfk5q")
    }
    
    func createProfileImageURL(_ image: UIImage,_ userID: UUID) async throws -> String {

        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
                throw NSError(domain: "Image", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to process image data"])
        }
        
        let filePath = "profiles/\(userID).jpg"

        return await uploadImageFetchURL(filePath, imageData) ?? ""
    }
    
    
    func createMapImageURL(_ image: UIImage, activityID: UUID) async throws -> String {

        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            throw NSError(domain: "Image", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to process image data"])
        }
        let filePath = "mapImage/\(activityID).jpg"

        
        return await uploadImageFetchURL(filePath, imageData) ?? ""
    }
}
