//
//  NotificationManager.swift
//  Runnr
//

//
//  NotificationManager.swift
//  Runnr
//

import Foundation
import Supabase
import UserNotifications

struct RunnrNotification: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let type: String
    let title: String
    let body: String?
    let data: [String: String]?
    var isRead: Bool
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case type
        case title
        case body
        case data
        case isRead = "is_read"
        case createdAt = "created_at"
    }
}

class NotificationManager {
    
    static let shared = NotificationManager()
    
    var notifications: [RunnrNotification] = []
    var unreadCount: Int = 0
    
    var onUpdate: (() -> Void)?
    
    private var channel: RealtimeChannelV2?
    
    private init() {}
    
    func start(userId: UUID) async {
        print("NotificationManager started for user: \(userId)")
        await fetchAll(userId: userId)
        await subscribeRealtime(userId: userId)
        requestLocalPermission()
    }
    
    func stop() async {
        await channel?.unsubscribe()
    }
    
    // MARK: - Fetch
    private func fetchAll(userId: UUID) async {
        do {
            let result: [RunnrNotification] = try await SupabaseManager.shared.client
                .from("notifications")
                .select()
                .eq("user_id", value: userId)
                .order("created_at", ascending: false)
                .limit(50)
                .execute()
                .value
            notifications = result
            unreadCount = result.filter { !$0.isRead }.count
            print("Fetched \(result.count) notifications")
            DispatchQueue.main.async { self.onUpdate?() }
        } catch {
            print("Notification fetch error: \(error)")
        }
    }
    
    // MARK: - Realtime
    private func subscribeRealtime(userId: UUID) async {
        channel = SupabaseManager.shared.client.realtimeV2.channel("notifications:\(userId)")
        
        let changes = await channel?.postgresChange(
            InsertAction.self,
            schema: "public",
            table: "notifications",
            filter: "user_id=eq.\(userId)"
        )
        
        await channel?.subscribe()
        
        guard let changes else { return }
        
        for await change in changes {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let notification = try? change.decodeRecord(as: RunnrNotification.self, decoder: decoder) {
                DispatchQueue.main.async {
                    self.notifications.insert(notification, at: 0)
                    self.unreadCount += 1
                    self.onUpdate?()
                    self.fireLocalNotification(notification)
                }
            }
        }
        
        // If we reach here, the channel closed — reconnect after 3 seconds
        print("Realtime channel closed, reconnecting...")
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        await subscribeRealtime(userId: userId)
    }
    
    // MARK: - Local Notification
    private func requestLocalPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                print("Notification permission granted: \(granted)")
            }
    }
    
    private func fireLocalNotification(_ n: RunnrNotification) {
        let content = UNMutableNotificationContent()
        content.title = n.title
        content.body = n.body ?? ""
        content.sound = .default
        content.badge = NSNumber(value: unreadCount)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: n.id.uuidString,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Mark Read
    func markAllRead() async {
        guard !notifications.isEmpty else { return }
        unreadCount = 0
        notifications = notifications.map { var n = $0; n.isRead = true; return n }
        DispatchQueue.main.async { self.onUpdate?() }
        
        try? await SupabaseManager.shared.client
            .from("notifications")
            .update(["is_read": true])
            .eq("user_id", value: notifications.first!.userId)
            .eq("is_read", value: false)
            .execute()
        
        try? await UNUserNotificationCenter.current().setBadgeCount(0)
    }
    
    func fetchLatest(userId: UUID) async {
        await fetchAll(userId: userId)
    }
    
    func markRead(_ id: UUID) async {
        notifications = notifications.map {
            var n = $0; if n.id == id { n.isRead = true }; return n
        }
        unreadCount = max(0, unreadCount - 1)
        DispatchQueue.main.async { self.onUpdate?() }
        
        try? await SupabaseManager.shared.client
            .from("notifications")
            .update(["is_read": true])
            .eq("id", value: id)
            .execute()
    }
}
