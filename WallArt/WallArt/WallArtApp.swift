//
//  WallArtApp.swift
//  WallArt
//
//  Created by m1 on 27/02/2025.
//

import SwiftUI

@main
struct WallArtApp: App {

    @State private var appModel = AppModel()
    
    init() {
        ImpactParticleSystem.registerSystem()
        ProjectileComponent.registerComponent()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }.windowStyle(.plain)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(appModel)
        }
        WindowGroup(id: "doodle_canvas") {
            DoodleView()
                .environment(appModel)
        }
        
     }
}
