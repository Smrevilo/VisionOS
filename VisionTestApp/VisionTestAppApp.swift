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
    
    var body: some Scene {
        WindowGroup {
            ContentView(score: $score)
        }
        ImmersiveSpace(id: "myImmersiveScene") {
            ImmersiveView()
        }
        ImmersiveSpace(id: "WhacAMole") {
            WhacAMoleView(score: $score)
        }
    }
}
