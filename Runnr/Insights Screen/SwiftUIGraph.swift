//
//  SwiftUIGraph.swift
//  Runnr
//
//  Created by SDC-USER on 04/03/26.
//

import SwiftUI
import Charts

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
