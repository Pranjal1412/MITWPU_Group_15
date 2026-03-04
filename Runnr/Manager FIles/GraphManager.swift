//
//  GraphManager.swift
//  Runnr
//
//  Created by SDC-USER on 19/11/25.
//

import Foundation
import SwiftUI
import Charts
import Combine

class GraphManager: ObservableObject {
    @Published var weeklyData: [SummaryRow] = []
    @Published var monthlyData: [SummaryRow] = []
    @Published var yearlyData: [SummaryRow] = []
    @Published var isLoading = false
    
    @Published var selectedPeriod: Period = .weekly

    // This helper transforms the raw rows into chart-ready DayData
    func chartData(for period: Period, metric: Metric) -> [DayData] {
        let rows: [SummaryRow]
        
        switch period {
            case .weekly:
                rows = weeklyData
            case .monthly:
                rows = monthlyData
            case .yearly:
                rows = yearlyData
        }

        return rows.map { row in
            // Choose the value based on the selected metric
            let value: Double
            switch metric {
                case .distance:
                    value = row.distance
                case .calories:
                    value = Double(row.calories)
                case .steps:
                    value = Double(row.steps)
                case .pace:
                    value = row.pace
            }

            // Create a label based on the date (e.g., "Mon", "Feb", etc.)
            let label = formatLabel(for: row.date, in: period)
            
            return DayData(label: label, value: value)
        }
    }

    private func formatLabel(for date: Date, in period: Period) -> String {
        let formatter = DateFormatter()
        switch period {
        case .weekly: formatter.dateFormat = "E" // "Mon", "Tue"
        case .monthly: formatter.dateFormat = "MMM" // "Jan", "Feb"
        case .yearly: formatter.dateFormat = "yyyy" // "2025"
        }
        return formatter.string(from: date)
    }

    // Call your fetchSummary function here to populate the arrays
    @MainActor
    func loadData(userID: UUID) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Fetch and store raw data
            if let weekly = try await fetchSummary(userID: userID, period: .weekly) {
                self.weeklyData = weekly
            }
            
            if let monthly = try await fetchSummary(userID: userID, period: .monthly) {
                self.monthlyData = monthly
            }
            
            if let yearly = try await fetchSummary(userID: userID, period: .yearly) {
                self.yearlyData = yearly
            }
            
        } catch {
            print("Error loading store: \(error)")
        }
    }
}
