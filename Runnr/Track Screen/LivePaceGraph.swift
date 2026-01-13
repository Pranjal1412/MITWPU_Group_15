import SwiftUI
import Charts

struct PacePoint: Identifiable {
    let id = UUID()
    let distance: Double
    let pace: Double
    let showSymbol: Bool   // true = show symbol, false = hide
    let symbolSize: CGFloat
}

struct LivePaceGraph: View {
    // Define all your points in an array
    let pacePoints: [PacePoint] = [
        PacePoint(distance: 0.5, pace: 6, showSymbol: false, symbolSize: 0),
        PacePoint(distance: 1, pace: 4, showSymbol: true, symbolSize: 70),
        PacePoint(distance: 1.5, pace: 6, showSymbol: false, symbolSize: 0),
        PacePoint(distance: 2, pace: 6, showSymbol: true, symbolSize: 70),
        PacePoint(distance: 2.5, pace: 5, showSymbol: false, symbolSize: 0),
        PacePoint(distance: 3, pace: 5, showSymbol: true, symbolSize: 100),
        PacePoint(distance: 3.5, pace: 5.5, showSymbol: false, symbolSize: 0),
        PacePoint(distance: 4, pace: 5.75, showSymbol: true, symbolSize: 100),
        PacePoint(distance: 4.5, pace: 6, showSymbol: false, symbolSize: 0),
        PacePoint(distance: 5, pace: 7, showSymbol: true, symbolSize: 100),
        PacePoint(distance: 7.5, pace: 8, showSymbol: false, symbolSize: 0)
    ]
    
    var body: some View {
        Chart {
            // AreaMarks
            ForEach(pacePoints) { point in
                AreaMark(x: .value("Distance", point.distance),
                         y: .value("Pace", point.pace))
                    .foregroundStyle(.accent.gradient.opacity(0.3))
            }
            
            // LineMarks
            ForEach(pacePoints) { point in
                LineMark(x: .value("Distance", point.distance),
                         y: .value("Pace", point.pace))
                
                // Only add symbol if showSymbol is true
                if point.showSymbol {
                    PointMark(x: .value("Distance", point.distance),
                              y: .value("Pace", point.pace))
                        .symbol(.circle) // default shape
                        .symbolSize(point.symbolSize)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
        .chartXAxis {
            AxisMarks { _ in
                AxisGridLine()
                    .foregroundStyle(.black.opacity(1))
                AxisTick()
                    .foregroundStyle(.black)
                AxisValueLabel()
                    .foregroundStyle(.black)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisGridLine()
                    .foregroundStyle(.black.opacity(1))
                AxisTick()
                    .foregroundStyle(.black)
                AxisValueLabel()
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    LivePaceGraph()
}
