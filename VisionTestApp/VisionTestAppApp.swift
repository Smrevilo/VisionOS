//
//  VisionTestAppApp.swift
//  VisionTestApp
//
//  Created by m1 on 18/02/2025.
//

import SwiftUI

@main
struct VisionTestAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        ImmersiveSpace(id: "myImmersiveScene") {
            ImmersiveView()
        }
        ImmersiveSpace(id: "WhacAMole") {
            WhacAMoleView()
        }
    }
}
