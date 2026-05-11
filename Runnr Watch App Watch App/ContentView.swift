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
                Text("Runnr.")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(Color("AccentColor"))
                
                Spacer()
                
                Button(action: {
                    workoutManager.startWorkout()
                }) {
                    Text("START")
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundColor(.black)
                        .frame(width: 100, height: 100)
                        .background(Color("AccentColor"))
                        .clipShape(Circle())
                        .shadow(color: Color("AccentColor").opacity(0.5), radius: 10)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
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
