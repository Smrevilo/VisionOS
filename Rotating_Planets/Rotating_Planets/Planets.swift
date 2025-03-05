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
        .gesture(TapGesture().targetedToAnyEntity().onEnded { value in
            let tappedEntity = value.entity
            
            Task{
                // 1. Calculate the transforms.
                let initialTransform = tappedEntity.transform

                // First target: 1/3 of a full rotation (120°) about the y-axis.
                var transformTarget1 = initialTransform
                let rotation120 = simd_quatf(angle: 2 * Float.pi / 3, axis: SIMD3<Float>(0,1,0))
                transformTarget1.rotation = initialTransform.rotation * rotation120

                // Second target: 2/3 of a full rotation (another 120° from target1, total 240°)
                var transformTarget2 = transformTarget1
                transformTarget2.rotation = transformTarget1.rotation * rotation120
                

                // 2. Define the duration for each segment.
                let duration: TimeInterval = 10

                // 3. Create the animations.
                let rotateSegment1 = FromToByAnimation(
                    from: initialTransform,
                    to: transformTarget1,
                    duration: duration,
                    timing: .linear,
                    bindTarget: .transform
                )

                let rotateSegment2 = FromToByAnimation(
                    from: transformTarget1,
                    to: transformTarget2,
                    duration: duration,
                    timing: .linear,
                    bindTarget: .transform,
                    delay: duration  // start after the first animation finishes
                )
                
                let rotateSegment3 = FromToByAnimation(
                    from: transformTarget2,
                    to: initialTransform,
                    duration: duration,
                    timing: .linear,
                    bindTarget: .transform,
                    delay: duration * 2  // start after the second animation finishes
                )

                // 4. Group them so they play in sequence and repeat.
                let rotateFullSequence = AnimationGroup(
                    group: [rotateSegment1, rotateSegment2, rotateSegment3],
                    repeatMode: .repeat
                )

                if let rotationAnimation = try? AnimationResource.generate(with: rotateFullSequence) {
                    tappedEntity.playAnimation(rotationAnimation, transitionDuration: 0.0, startsPaused: false)
                }
            }
            
        })
        .onAppear() {
            dismissWindow(id: "main")
        }
    }
}


#Preview {
    Planets()
}
