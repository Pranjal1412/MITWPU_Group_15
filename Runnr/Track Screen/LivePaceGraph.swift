//import SwiftUI
//import Charts
//
//// MARK: - Data Model
//struct DayData: Identifiable {
//    let id = UUID()
//    let day: String
//    let value: Double
//}
//
//// MARK: - Responsive Bar Chart (Auto-Fit Width)
//struct ResponsiveBarChart: View {
//    let data: [DayData]
//    let maxY: Double
//
//    var body: some View {
//        GeometryReader { geo in
//            let totalWidth = geo.size.width
//            let barCount = CGFloat(data.count)
//            let barWidth = (totalWidth / barCount) * 0.7   // 70% bar, 30% spacing
//
//            Chart {
//                ForEach(data) { item in
//                    BarMark(
//                        x: .value("Day", item.day),
//                        y: .value("Value", item.value)
//                    )
//                    .foregroundStyle(Color.accentColor)
//                    .cornerRadius(5)
//                }
//            }
//            .chartYScale(domain: 0...maxY)
//            .chartXScale(
//                range: .plotDimension(
//                    startPadding: barWidth / 2,
//                    endPadding: barWidth / 2
//                )
//            )
//            .chartXAxis {
//                AxisMarks(values: data.map { $0.day }) { value in
//                    AxisGridLine().foregroundStyle(.black.opacity(0.2))
//                    AxisTick()
//                    AxisValueLabel {
//                        if let day = value.as(String.self) {
//                            Text(day)
//                                .font(.system(size: 12, weight: .bold))
//                        }
//                    }
//                }
//            }
//            .chartYAxis {
//                AxisMarks(position: .leading) { _ in
//                    AxisGridLine().foregroundStyle(.black.opacity(0.2))
//                    AxisTick()
//                    AxisValueLabel()
//                }
//            }
//        }
//        .frame(height: 300)
//        .padding()
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
//    }
//}
//
//
//// MARK: - Main View
//struct FitnessChartsView: View {
//    @State private var selectedSegment = "Weekly"
//    let segments = ["Weekly", "Monthly", "Yearly"]
//
//    var body: some View {
//        VStack(spacing: 16) {
//            Picker("Segment", selection: $selectedSegment) {
//                ForEach(segments, id: \.self) {
//                    Text($0)
//                }
//            }
//            .pickerStyle(.segmented)
//            .padding(.horizontal)
//
//            ScrollView {
//                VStack(spacing: 20) {
//                    switch selectedSegment {
//                    case "Weekly":
//                        ResponsiveBarChart(data: weeklyPace, maxY: 6)
//                        ResponsiveBarChart(data: weeklyDistance, maxY: 8)
//                        ResponsiveBarChart(data: weeklySteps, maxY: 10000)
//                        ResponsiveBarChart(data: weeklyCalories, maxY: 400)
//
//                    case "Monthly":
//                        ResponsiveBarChart(data: monthlyPace, maxY: 35)
//                        ResponsiveBarChart(data: monthlyDistance, maxY: 25)
//                        ResponsiveBarChart(data: monthlySteps, maxY: 50000)
//                        ResponsiveBarChart(data: monthlyCalories, maxY: 1500)
//
//                    case "Yearly":
//                        ResponsiveBarChart(data: yearlyPace, maxY: 180)
//                        ResponsiveBarChart(data: yearlyDistance, maxY: 100)
//                        ResponsiveBarChart(data: yearlySteps, maxY: 250000)
//                        ResponsiveBarChart(data: yearlyCalories, maxY: 6500)
//
//                    default:
//                        EmptyView()
//                    }
//                }
//                .padding()
//            }
//        }
//        .background(Color.white.ignoresSafeArea())
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    FitnessChartsView()
//}
