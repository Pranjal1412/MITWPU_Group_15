import SwiftUI
import Charts

// MARK: - Data Model
struct DayData: Identifiable {
    let id = UUID()
    let day: String
    let value: Double
}

// MARK: - Scrollable Bar Chart with Grid & Static Width
struct ScrollableBarChart: View {
    let data: [DayData]
    let maxY: Double
    let barWidth: CGFloat = 30
    let spacing: CGFloat = 20
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Chart {
                ForEach(data) { item in
                    BarMark(
                        x: .value("Day", item.day),
                        y: .value("Value", item.value)
                    )
                    .cornerRadius(6)
                    .foregroundStyle(Color.accentColor)
                }
            }
            .chartXScale(range: .plotDimension(startPadding: spacing, endPadding: spacing))
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine().foregroundStyle(Color.black.opacity(0.3))
                    AxisTick().foregroundStyle(Color.gray)
                    AxisValueLabel().foregroundStyle(Color.black)
                }
            }
            .chartXAxis {
                AxisMarks(values: data.map { $0.day }) { value in
                    AxisGridLine().foregroundStyle(Color.black.opacity(0.3))
                    AxisTick().foregroundStyle(Color.gray)
                    AxisValueLabel {
                        if let day = value.as(String.self) {
                            Text(day)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .frame(width: max(CGFloat(data.count) * (barWidth + spacing), UIScreen.main.bounds.width - 40),
                   height: 300)
            .padding(.vertical, 15)
        }
        .padding(.horizontal, 12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Sample Data
let weeklyPace: [DayData] = [
    .init(day: "M", value: 5.2), .init(day: "T", value: 4.8),
    .init(day: "W", value: 5.0), .init(day: "T", value: 5.5),
    .init(day: "F", value: 4.9), .init(day: "S", value: 5.3),
    .init(day: "S", value: 5.1)
]

let weeklyDistance: [DayData] = [
    .init(day: "M", value: 3.5), .init(day: "T", value: 5.2),
    .init(day: "W", value: 4.0), .init(day: "T", value: 6.3),
    .init(day: "F", value: 5.0), .init(day: "S", value: 7.1),
    .init(day: "S", value: 4.8)
]

let weeklySteps: [DayData] = [
    .init(day: "M", value: 6500), .init(day: "T", value: 7200),
    .init(day: "W", value: 6800), .init(day: "T", value: 8000),
    .init(day: "F", value: 7500), .init(day: "S", value: 9000),
    .init(day: "S", value: 8200)
]

let weeklyCalories: [DayData] = [
    .init(day: "M", value: 250), .init(day: "T", value: 300),
    .init(day: "W", value: 280), .init(day: "T", value: 320),
    .init(day: "F", value: 290), .init(day: "S", value: 350),
    .init(day: "S", value: 310)
]

// Monthly
let monthlyPace: [DayData] = [
    .init(day: "W1", value: 25), .init(day: "W2", value: 28),
    .init(day: "W3", value: 26), .init(day: "W4", value: 30)
]

let monthlyDistance: [DayData] = [
    .init(day: "W1", value: 15), .init(day: "W2", value: 18),
    .init(day: "W3", value: 17), .init(day: "W4", value: 20)
]

let monthlySteps: [DayData] = [
    .init(day: "W1", value: 40000), .init(day: "W2", value: 45000),
    .init(day: "W3", value: 42000), .init(day: "W4", value: 48000)
]

let monthlyCalories: [DayData] = [
    .init(day: "W1", value: 1200), .init(day: "W2", value: 1350),
    .init(day: "W3", value: 1280), .init(day: "W4", value: 1400)
]

// Yearly
let yearlyPace: [DayData] = [
    .init(day: "Jan", value: 100), .init(day: "Feb", value: 120),
    .init(day: "Mar", value: 110), .init(day: "Apr", value: 130),
    .init(day: "May", value: 125), .init(day: "Jun", value: 140),
    .init(day: "Jul", value: 135), .init(day: "Aug", value: 145),
    .init(day: "Sep", value: 150), .init(day: "Oct", value: 160),
    .init(day: "Nov", value: 155), .init(day: "Dec", value: 165)
]

let yearlyDistance: [DayData] = [
    .init(day: "Jan", value: 60), .init(day: "Feb", value: 65),
    .init(day: "Mar", value: 63), .init(day: "Apr", value: 70),
    .init(day: "May", value: 68), .init(day: "Jun", value: 75),
    .init(day: "Jul", value: 72), .init(day: "Aug", value: 78),
    .init(day: "Sep", value: 80), .init(day: "Oct", value: 85),
    .init(day: "Nov", value: 82), .init(day: "Dec", value: 90)
]

let yearlySteps: [DayData] = [
    .init(day: "Jan", value: 160000), .init(day: "Feb", value: 170000),
    .init(day: "Mar", value: 165000), .init(day: "Apr", value: 180000),
    .init(day: "May", value: 175000), .init(day: "Jun", value: 190000),
    .init(day: "Jul", value: 185000), .init(day: "Aug", value: 200000),
    .init(day: "Sep", value: 205000), .init(day: "Oct", value: 210000),
    .init(day: "Nov", value: 205000), .init(day: "Dec", value: 220000)
]

let yearlyCalories: [DayData] = [
    .init(day: "Jan", value: 4800), .init(day: "Feb", value: 5000),
    .init(day: "Mar", value: 4900), .init(day: "Apr", value: 5200),
    .init(day: "May", value: 5100), .init(day: "Jun", value: 5400),
    .init(day: "Jul", value: 5300), .init(day: "Aug", value: 5600),
    .init(day: "Sep", value: 5700), .init(day: "Oct", value: 5900),
    .init(day: "Nov", value: 5800), .init(day: "Dec", value: 6000)
]

// MARK: - Main View with Segment Control
struct FitnessChartsView: View {
    @State private var selectedSegment = "Weekly"
    let segments = ["Weekly", "Monthly", "Yearly"]
    
    var body: some View {
        VStack(spacing: 20) {
            Picker("Segment", selection: $selectedSegment) {
                ForEach(segments, id: \.self) { segment in
                    Text(segment).tag(segment)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 20) {
                    switch selectedSegment {
                    case "Weekly":
                        ScrollableBarChart(data: weeklyPace, maxY: 6)
                        ScrollableBarChart(data: weeklyDistance, maxY: 8)
                        ScrollableBarChart(data: weeklySteps, maxY: 10000)
                        ScrollableBarChart(data: weeklyCalories, maxY: 400)
                    case "Monthly":
                        ScrollableBarChart(data: monthlyPace, maxY: 35)
                        ScrollableBarChart(data: monthlyDistance, maxY: 25)
                        ScrollableBarChart(data: monthlySteps, maxY: 50000)
                        ScrollableBarChart(data: monthlyCalories, maxY: 1500)
                    case "Yearly":
                        ScrollableBarChart(data: yearlyPace, maxY: 180)
                        ScrollableBarChart(data: yearlyDistance, maxY: 100)
                        ScrollableBarChart(data: yearlySteps, maxY: 250000)
                        ScrollableBarChart(data: yearlyCalories, maxY: 6500)
                    default:
                        EmptyView()
                    }
                }
                .padding()
            }
        }
        .background(Color.white.ignoresSafeArea())
    }
}

// MARK: - Preview
#Preview {
    FitnessChartsView()
}
