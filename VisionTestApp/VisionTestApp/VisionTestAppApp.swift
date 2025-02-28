//
//  VisionTestAppApp.swift
//  VisionTestApp
//
//  Created by m1 on 18/02/2025.
//

import SwiftUI

@main
struct VisionTestAppApp: App {
    @State private var score: Int = 0
    @State private var timeRemaning = 20
    
    var body: some Scene {
        WindowGroup {
            ContentView(score: $score, timeRemaning: $timeRemaning)
        }
        ImmersiveSpace(id: "WhacAMole") {
            WhacAMoleView(score: $score, timeRemaning: $timeRemaning)
        }
    }
}
