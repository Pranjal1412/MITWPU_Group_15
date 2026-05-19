//
//  ContentView.swift
//  Runnr Watch App Watch App
//
//  Created by Archit Kankaria on 10/05/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var workoutManager = WorkoutManager()

    var body: some View {
        VStack {
            if workoutManager.running {
                Text("Running")
                    .font(.headline)
                    .foregroundColor(.green)

                HStack {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    Text("\(workoutManager.heartRate, specifier: "%.0f") bpm")
                }

                Text("\(workoutManager.distance / 1000, specifier: "%.2f") km")

                Button("End Run") {
                    workoutManager.endWorkout()
                }
                .tint(.red)
            } else {
                Text("Ready to Run")

                Button("Start Run") {
                    workoutManager.startWorkout()
                }
                .tint(.green)
            }
        }
        .padding()
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}

#Preview {
    ContentView()
}
