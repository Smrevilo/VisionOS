//
//  ContentView.swift
//  VisionTestApp
//
//  Created by m1 on 18/02/2025.
//

import SwiftUI
import Charts

struct DataPoint: Identifiable {
    let id = UUID()
    let day: String
    let value: Double
}

let sampleData: [DataPoint] = [
    DataPoint(day: "Mon", value: 5.0),
    DataPoint(day: "Tue", value: 7.3),
    DataPoint(day: "Wed", value: 4.3),
    DataPoint(day: "Thu", value: 5.3),
    DataPoint(day: "Fri", value: 6.3),
    DataPoint(day: "Sat", value: 7.0),
    DataPoint(day: "Sun", value: 7.6)
    
]


struct ContentView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @State private var goToNext = false
    
    @Binding private var score: Int
    @Binding private var timeRemaning: Int
    @State private var gameActive: Bool = false
    @State private var timer: Timer?
    
    init(score: Binding<Int>, timeRemaning: Binding<Int>) {
        self._score = score
        self._timeRemaning = timeRemaning
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to Vision Pro!")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Text("Score \(score)")
                    .font(.title2)
                    .padding()
                
                Text("Time remaining \(timeRemaning)")
                    .font(.title3)
                    .foregroundColor(timeRemaning > 5 ? .white : .red)
                    .padding()
                
                Button("Go to second screen") {
                    goToNext = true
                }
                
                Button("Enter Immersive Scene") {
                    startGame()
                }
            }
            .navigationDestination(isPresented: $goToNext) {
                SecondView()
            }
            .navigationTitle("Main Screen")
            
        }
        .opacity(gameActive ? 0 : 1)
        .disabled(gameActive)
    }
    
    private func startGame() {
        gameActive = true
        score = 0
        timeRemaning = 20
        
        Task {
            await openImmersiveSpace(id: "WhacAMole")
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            _ in
            if timeRemaning > 0 {
                timeRemaning -= 1
            } else {
                endGame()
            }
            
        }
        
    }
    
    private func endGame() {
        gameActive = false
        timer?.invalidate() // ✅ Stop the timer
        timer = nil

        Task {
            await dismissImmersiveSpace()
        }
    }
}


struct SecondView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("This is the second screen!")
                .font(.title)
                .padding()
            
            NavigationLink("Go to Third Screen", destination: GraphView())
                .padding()
                .buttonStyle(.bordered)
            
            Button("Go Back") {
                dismiss()
            }
        }
        .navigationTitle("Second Screen")
    }
}

struct GraphView: View {
    var body: some View {
        Chart(sampleData) {
            dataPoint in BarMark(
                x: .value("Day", dataPoint.day),
                y: .value("value", dataPoint.value)
            )
        }
        .frame(height: 300)
        .padding()
    }
}



