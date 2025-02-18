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
    
    @State private var goToNext = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to Vision Pro!")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Button("Go to second screen") {
                    goToNext = true
                }
            }
            .navigationDestination(isPresented: $goToNext) {
                SecondView()
            }
            .navigationTitle("Main Screen")
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


#Preview {
    ContentView()
}
