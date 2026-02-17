//
//  cardData.swift
//  Runnr
//
//  Created by SDC-USER on 19/11/25.
//

import Foundation
import SwiftUI
import Charts
import Combine

struct DayData: Identifiable, Equatable {
    let id = UUID()
    let label: String
    let value: Double
}

struct SummaryRow: Decodable {
    // Supabase returns dates as Strings (ISO8601)
    private let timeGroup: String
    let distance: Double
    let calories: Int
    let steps: Int
    let pace: Double

    // Use this in your UI
    var date: Date {
        let formatter = DateFormatter()
        // This matches your specific string: "YYYY-MM-DDTHH:MM:SS"
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        // Set locale to ensure it doesn't break on users with non-US settings
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        if let parsedDate = formatter.date(from: timeGroup) {
            return parsedDate
        }

        // If it still fails, use a "Sentinel" date so you know it's broken
        // (Jan 1 1970 will show up as 'Thu' or '1970')
        return Date(timeIntervalSince1970: 0)
    }
    
    enum CodingKeys: String, CodingKey {
        case timeGroup = "timeGroup" // Matches the quoted SQL name exactly
        case distance, calories, steps, pace
    }
}

final class GraphDataStore: ObservableObject {
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

struct ResponsiveBarChart: View {
    let data: [DayData]
    
    var maxYValue : DayData? {
        data.max { $0.value < $1.value }
    }
    
    var body: some View {
        GeometryReader { geo in
            let barWidth = (geo.size.width / CGFloat(data.count)) * 0.3
            
            Chart {
                ForEach(data) { item in
                    BarMark(
                        x: .value("Label", item.label),
                        y: .value("Value", item.value)
                    )
                    .foregroundStyle(.accent)
                    .cornerRadius(6)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: data)
            .chartYScale(domain: 0...(maxYValue?.value ?? 1))
            .chartXScale(
                range: .plotDimension(
                    startPadding: barWidth / 2,
                    endPadding: barWidth / 2
                )
            )
            .chartXAxis {
                AxisMarks(values: data.map { $0.label }) { value in
                    AxisGridLine()
                        .foregroundStyle(.white.opacity(0.6))
                    AxisTick()
                        .foregroundStyle(.white)
                    AxisValueLabel()
                        .foregroundStyle(.white)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine()
                        .foregroundStyle(.white.opacity(0.6))
                    AxisTick()
                        .foregroundStyle(.white)
                    AxisValueLabel()
                        .foregroundStyle(.white)
                }
                
            }
        }
        .background(Color.black)
    }
}
