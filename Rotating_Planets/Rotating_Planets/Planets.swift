//
//  Planets.swift
//  Rotating_Planets
//
//  Created by m1 on 03/03/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct Planets: View {
    
    @Environment(\.dismissWindow) var dismissWindow
    
    @State private var mercuryEntity: Entity?
    @State private var venusEntity: Entity?
    @State private var earthEntity: Entity?
    @State private var marsEntity: Entity?
    @State private var jupiterEntity: Entity?
    @State private var saturnEntity: Entity?
    @State private var uranusEntity: Entity?
    @State private var neptuneEntity: Entity?
    
    @State private var updateTimer: Timer?
    
    
    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "Planets", in: realityKitContentBundle) {
                content.add(scene)
                mercuryEntity = scene.findEntity(named: "Mercury")
                venusEntity   = scene.findEntity(named: "Venus")
                earthEntity   = scene.findEntity(named: "Earth")
                marsEntity    = scene.findEntity(named: "Mars")
                jupiterEntity = scene.findEntity(named: "Jupiter")
                saturnEntity  = scene.findEntity(named: "Saturn")
                uranusEntity  = scene.findEntity(named: "Uranus")
                neptuneEntity = scene.findEntity(named: "Neptune")
            }
           
        }
        .gesture(TapGesture().targetedToAnyEntity().onEnded { _ in
            // Start a timer to update rotations:
            updateTimer?.invalidate()
            updateTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                // Define unique angular increments (in radians per update)
                let mercurySpeed: Float = 0.01
                let venusSpeed: Float   = 0.008
                let earthSpeed: Float   = 0.007
                let marsSpeed: Float    = 0.005
                let jupiterSpeed: Float = 0.003
                let saturnSpeed: Float  = 0.002
                let uranusSpeed: Float  = 0.01
                let neptuneSpeed: Float = 0.018
                
                // For each planet, apply a rotation increment around the Y-axis:
                if let mercury = mercuryEntity {
                    var transform = mercury.transform
                    let rotation = simd_quatf(angle: mercurySpeed, axis: SIMD3<Float>(0,1,0))
                    transform.rotation *= rotation
                    mercury.transform = transform
                }
                if let venus = venusEntity {
                    var transform = venus.transform
                    let rotation = simd_quatf(angle: venusSpeed, axis: SIMD3<Float>(0,1,0))
                    transform.rotation *= rotation
                    venus.transform = transform
                }
                if let earth = earthEntity {
                    var transform = earth.transform
                    let rotation = simd_quatf(angle: earthSpeed, axis: SIMD3<Float>(0,1,0))
                    transform.rotation *= rotation
                    earth.transform = transform
                }
                if let mars = marsEntity {
                    var transform = mars.transform
                    let rotation = simd_quatf(angle: marsSpeed, axis: SIMD3<Float>(0,1,0))
                    transform.rotation *= rotation
                    mars.transform = transform
                }
                if let jupiter = jupiterEntity {
                    var transform = jupiter.transform
                    let rotation = simd_quatf(angle: jupiterSpeed, axis: SIMD3<Float>(0,1,0))
                    transform.rotation *= rotation
                    jupiter.transform = transform
                }
                if let saturn = saturnEntity {
                    var transform = saturn.transform
                    let rotation = simd_quatf(angle: saturnSpeed, axis: SIMD3<Float>(0,1,0))
                    transform.rotation *= rotation
                    saturn.transform = transform
                }
                if let uranus = uranusEntity {
                    var transform = uranus.transform
                    let rotation = simd_quatf(angle: uranusSpeed, axis: SIMD3<Float>(0,1,0))
                    transform.rotation *= rotation
                    uranus.transform = transform
                }
                if let neptune = neptuneEntity {
                    var transform = neptune.transform
                    let rotation = simd_quatf(angle: neptuneSpeed, axis: SIMD3<Float>(0,1,0))
                    transform.rotation *= rotation
                    neptune.transform = transform
                }
            }
            updateTimer?.fire()
        })
        .onAppear() {
            dismissWindow(id: "main")
        }
    }
}


#Preview {
    Planets()
}
