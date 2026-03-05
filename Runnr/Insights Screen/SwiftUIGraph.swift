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
    @State private var selectedItem: DayData?

    var maxYValue: Double {
        data.map{$0.value}.max() ?? 1
    }

    var body: some View {

        GeometryReader { geo in

            Chart {

                ForEach(data) { item in

                    BarMark(
                        x: .value("Label", item.label),
                        y: .value("Value", item.value)
                    )
                    .foregroundStyle(.accent)
                    .cornerRadius(6)

                    if selectedItem?.id == item.id {

                        PointMark(
                            x: .value("Label", item.label),
                            y: .value("Value", item.value)
                        )
                        .annotation(position: .top) {
                            VStack(spacing: 6) {
                                Text("TOTAL")
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white) // changed to white

                                Text("\(Int(item.value))")
                                    .font(.title) // increased font size for emphasis
                                    .fontWeight(.bold)
                                    .foregroundColor(.white) // changed to white

                                Text(item.label)
                                    .font(.caption)
                                    .foregroundColor(.white) // changed to white

                                Circle()
                                    .fill(Color.accentColor)
                                    .frame(width: 8, height: 8)
                                    .offset(y: 6)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color("CardLightBlack")) // dark grey background
                                    .shadow(color: .black.opacity(0.25), radius: 6, y: 3)
                            )
                        }
                    }
                }
            }

            .animation(.easeInOut(duration: 0.25), value: selectedItem)

            .chartYScale(domain: 0...maxYValue)

            .chartXAxis {
                AxisMarks(values: data.map{$0.label}) { value in
                    AxisGridLine()
                        .foregroundStyle(.white.opacity(0.5))
                    AxisTick()
                        .foregroundStyle(.white)
                    AxisValueLabel()
                        .foregroundStyle(.white)
                }
            }

            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine()
                        .foregroundStyle(.white.opacity(0.5))
                    AxisTick()
                        .foregroundStyle(.white)
                    AxisValueLabel()
                        .foregroundStyle(.white)
                }
            }

            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let xPosition = value.location.x -
                                        geometry[proxy.plotAreaFrame].origin.x

                                    if let label: String = proxy.value(atX: xPosition),
                                       let item = data.first(where: { $0.label == label }) {

                                        // Toggle selection: deselect if already selected
                                        if selectedItem?.id == item.id {
                                            selectedItem = nil
                                        } else {
                                            selectedItem = item
                                        }
                                    }
                                }
                        )
                }
            }
     }

        .background(Color.black)
    }
}


//import SwiftUI
//import Charts
//
//struct ResponsiveBarChart: View {
//    let data: [DayData]
//    
//    var maxYValue : DayData? {
//        data.max { $0.value < $1.value }
//    }
//    
//    var body: some View {
//        GeometryReader { geo in
//            let barWidth = (geo.size.width / CGFloat(data.count)) * 0.3
//            
//            Chart {
//                ForEach(data) { item in
//                    BarMark(
//                        x: .value("Label", item.label),
//                        y: .value("Value", item.value)
//                    )
//                    .foregroundStyle(.accent)
//                    .cornerRadius(6)
//                }
//            }
//            .animation(.easeInOut(duration: 0.5), value: data)
//            .chartYScale(domain: 0...(maxYValue?.value ?? 1))
//            .chartXScale(
//                range: .plotDimension(
//                    startPadding: barWidth / 2,
//                    endPadding: barWidth / 2
//                )
//            )
//            .chartXAxis {
//                AxisMarks(values: data.map { $0.label }) { value in
//                    AxisGridLine()
//                        .foregroundStyle(.white.opacity(0.6))
//                    AxisTick()
//                        .foregroundStyle(.white)
//                    AxisValueLabel()
//                        .foregroundStyle(.white)
//                }
//            }
//            .chartYAxis {
//                AxisMarks(position: .leading) { _ in
//                    AxisGridLine()
//                        .foregroundStyle(.white.opacity(0.6))
//                    AxisTick()
//                        .foregroundStyle(.white)
//                    AxisValueLabel()
//                        .foregroundStyle(.white)
//                }
//                
//            }
//        }
//        .background(Color.black)
//    }
//}
