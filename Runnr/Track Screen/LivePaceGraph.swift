//
//  LivePaveGraph.swift
//  Runnr
//
//  Created by Pranjal Shinde on 10/01/26.
//

import SwiftUI
import Charts

struct LivePaceGraph: View {
    var body: some View {
        Chart {
            LineMark(x: .value("Distance", "1 Km"), y: .value("Pace", 4))
                .symbol(.square)
                .symbolSize(100)
            
            LineMark(x: .value("Distance", "2 Km"), y: .value("Pace", 6))
                .symbol(.circle)
                .symbolSize(100)
            
            LineMark(x: .value("Distance", "3 Km"), y: .value("Pace", 5))
                .symbol(.circle)
                .symbolSize(100)
            
            LineMark(x: .value("Distance", "4 Km"), y: .value("Pace", 5.75))
                .symbol(.circle)
                .symbolSize(100)
            
            LineMark(x: .value("Distance", "5 Km"), y: .value("Pace", 7))
                .symbol(.square)
                .symbolSize(100)
            
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

//#Preview {
//    LivePaceGraph()
//}
