//
//  Rotating_PlanetsApp.swift
//  Rotating_Planets
//
//  Created by m1 on 03/03/2025.
//

import SwiftUI

@main
struct Rotating_PlanetsApp: App {

    var body: some Scene {
        WindowGroup(id: "main") {
            ContentView()
        }
        ImmersiveSpace(id: "saturn") {
            Planets()
        }
     }
}
