//
//  SupabaseManager.swift
//  Runnr
//
//  Created by SDC-USER on 31/01/26.
//

import Supabase
import Foundation

class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        self.client = SupabaseClient(supabaseURL: URL(string: "https://sopdroanstpbthnxpvxr.supabase.co")!, supabaseKey: "sb_publishable_a-5EbK84aAtodb0M3SJR7w_ZuCmfk5q")
    }
    
}
