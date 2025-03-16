//
//  Inspiration4AppApp.swift
//  Inspiration4App
//
//  Created by m1 on 13/03/2025.
//

import SwiftUI

@main
struct Inspiration4AppApp: App {
    @State private var model = ViewModel()

    var body: some Scene {
        WindowGroup {
            Areas()
                .environment(model)
        }
        
        WindowGroup(id: model.capsuleRealityAreaId) {
            CapsuleRealityArea()
                .environment(model)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.6, height: 0.6, depth: 0.6, in: .meters)
        
        ImmersiveSpace(id: model.fullRocketRealityAreaId) {
            FullRocketRealityArea()
                .environment(model)
        }
        .immersionStyle(selection: .constant(.full), in: .full)
        
        ImmersiveSpace(id: model.mixedRocketRealityAreaId) {
            FullRocketRealityArea()
                .environment(model)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
