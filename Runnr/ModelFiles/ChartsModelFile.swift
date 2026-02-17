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
        let formatter = ISO8601DateFormatter()
        // Supabase often includes fractional seconds (e.g., .000Z)
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: timeGroup) ?? Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case timeGroup = "timeGroup" // Matches the quoted SQL name exactly
        case distance, calories, steps, pace
    }
}

final class GraphDataStore: ObservableObject {
    @Published var data: [DayData] = []
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
            .chartYScale(domain: 0...maxYValue!.value)
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
// MARK: - Distance Data
let weeklyPace: [DayData] = [
    .init(label: "Mon", value: 5.2), .init(label: "Tue", value: 4.8),
    .init(label: "Wed", value: 5.0), .init(label: "Thu", value: 5.5),
    .init(label: "Fri", value: 4.9), .init(label: "Sat", value: 5.3),
    .init(label: "Sun", value: 5.1)
]

let weeklyDistance: [DayData] = [
    .init(label: "Mon", value: 3.5), .init(label: "Tue", value: 5.2),
    .init(label: "Wed", value: 4.0), .init(label: "Thu", value: 6.3),
    .init(label: "Fri", value: 5.0), .init(label: "Sat", value: 7.1),
    .init(label: "Sun", value: 4.8)
]

let weeklySteps: [DayData] = [
    .init(label: "Mon", value: 6500), .init(label: "Tue", value: 7200),
    .init(label: "Wed", value: 6800), .init(label: "Thu", value: 8000),
    .init(label: "Fri", value: 7500), .init(label: "Sat", value: 9000),
    .init(label: "Sun", value: 8200)
]

let weeklyCalories: [DayData] = [
    .init(label: "Mon", value: 250), .init(label: "Tue", value: 300),
    .init(label: "Wed", value: 280), .init(label: "Thu", value: 320),
    .init(label: "Fri", value: 290), .init(label: "Sat", value: 350),
    .init(label: "Sun", value: 310)
]

// MARK: - Yearly Data
let yearlyPace: [DayData] = [
    .init(label: "2023", value: 7), .init(label: "2024", value: 8),
    .init(label: "2025", value: 5), .init(label: "2026", value: 6)
]

let yearlyDistance: [DayData] = [
    .init(label: "2023", value: 290), .init(label: "2024", value: 318),
    .init(label: "2025", value: 403), .init(label: "2026", value: 458)
]

let yearlySteps: [DayData] = [
    .init(label: "2023", value: 40000), .init(label: "2024", value: 45000),
    .init(label: "2025", value: 42000), .init(label: "2026", value: 48000)
]

let yearlyCalories: [DayData] = [
    .init(label: "2023", value: 1200), .init(label: "2024", value: 1350),
    .init(label: "2025", value: 1280), .init(label: "2026", value: 1400)
]

// MARK: - Monthly Data
let monthlyPace: [DayData] = [
    .init(label: "J", value: 100), .init(label: "F", value: 120),
    .init(label: "M", value: 110), .init(label: "A", value: 130),
    .init(label: "Ma", value: 125), .init(label: "Ju", value: 140),
    .init(label: "Jul", value: 135), .init(label: "Au", value: 145),
    .init(label: "S", value: 150), .init(label: "O", value: 160),
    .init(label: "N", value: 155), .init(label: "D", value: 165)
]

let monthlyDistance: [DayData] = [
    .init(label: "J", value: 60), .init(label: "F", value: 65),
    .init(label: "M", value: 63), .init(label: "A", value: 70),
    .init(label: "Ma", value: 68), .init(label: "Ju", value: 75),
    .init(label: "Jul", value: 72), .init(label: "Au", value: 78),
    .init(label: "S", value: 80), .init(label: "O", value: 85),
    .init(label: "N", value: 82), .init(label: "D", value: 90)
]

let monthlySteps: [DayData] = [
    .init(label: "J", value: 160000), .init(label: "F", value: 170000),
    .init(label: "M", value: 165000), .init(label: "A", value: 180000),
    .init(label: "Ma", value: 175000), .init(label: "Ju", value: 190000),
    .init(label: "Jul", value: 185000), .init(label: "Au", value: 200000),
    .init(label: "S", value: 205000), .init(label: "O", value: 210000),
    .init(label: "N", value: 205000), .init(label: "D", value: 220000)
]

let monthlyCalories: [DayData] = [
    .init(label: "J", value: 4800), .init(label: "F", value: 5000),
    .init(label: "M", value: 4900), .init(label: "A", value: 5200),
    .init(label: "Ma", value: 5100), .init(label: "Ju", value: 5400),
    .init(label: "Jul", value: 5300), .init(label: "Au", value: 5600),
    .init(label: "S", value: 5700), .init(label: "O", value: 5900),
    .init(label: "N", value: 5800), .init(label: "D", value: 6000)
]


