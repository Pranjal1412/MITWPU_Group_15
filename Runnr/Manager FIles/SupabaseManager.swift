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
    
    func uploadProfileImage(image: UIImage, userID: String) async throws -> String? {
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw URLError(.badURL)
        }

        let filePath = "profiles/\(userID).jpg"
        
        return await insertProfileImageURL(with: filePath, imageData: imageData)
    }

}
