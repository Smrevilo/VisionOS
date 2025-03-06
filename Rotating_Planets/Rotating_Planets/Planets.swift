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
    
    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "Planets", in: realityKitContentBundle) {
                content.add(scene)
                
            }
           
        }
        .gesture(TapGesture().targetedToAnyEntity().onEnded { value in
            if value.entity.parent?.parent?.name == "Orbiting_planets" {
                if value.entity.name == "Earth" {
                    Planets.moonOrbit(tappedEntity: value.entity)
                }
                Planets.animatePlanets(tappedEntity: value.entity)
            } else {
                Planets.animateSun(tappedEntity: value.entity)
            }
        })
        .onAppear() {
            dismissWindow(id: "main")
        }
    }
    
    static private func moonOrbit(tappedEntity: Entity) {
        if let moon = tappedEntity.parent?.findEntity(named: "Moon_orbit") {
            print("fundet")
            Task {
                let yAxis: SIMD3<Float> = [0, 1, 0]
                let orbit = OrbitAnimation(
                    name: "MoonOrbit",
                    duration: 5,
                    axis: yAxis,
                    startTransform: moon.transform,
                    spinClockwise: true,
                    orientToPath: true,
                    bindTarget: .transform,
                    repeatMode: .repeat
                )
                
                if let orbitAnimationResource = try? AnimationResource.generate(with: orbit) {
                    moon.playAnimation(orbitAnimationResource, transitionDuration:0.0, startsPaused: false)
                }
            }
        }
    }
    
    static private func animateSun(tappedEntity: Entity) {
        Task{
            let rotateFullSequence = Planets.createRotationAnimation(initialTransform:tappedEntity.transform)
            
            if let rotationAnimation = try? AnimationResource.generate(with: rotateFullSequence){
                tappedEntity.playAnimation(rotationAnimation, transitionDuration: 0.0,startsPaused:false)
            }
        
        }
    }
    
    static private func animatePlanets(tappedEntity: Entity) {
        if let planetOrbit = tappedEntity.parent {
            Task{
                let rotateFullSequence = Planets.createRotationAnimation(initialTransform:tappedEntity.transform)
            
                let yAxis: SIMD3<Float> = [0, 1, 0]
                let orbit = OrbitAnimation(
                    name: "orbit",
                    duration: TimeInterval(Int.random(in: 40...90)),
                    axis: yAxis,
                    startTransform: planetOrbit.transform,
                    spinClockwise: false,
                    orientToPath: true,
                    bindTarget: .transform,
                    repeatMode: .repeat
                )
                
                if let orbitAnimationResource = try? AnimationResource.generate(with: orbit) {
                    planetOrbit.playAnimation(orbitAnimationResource, transitionDuration:0.0, startsPaused: false)
                }
                
                
                if let rotationAnimation = try? AnimationResource.generate(with: rotateFullSequence){
                    tappedEntity.playAnimation(rotationAnimation, transitionDuration: 0.0,startsPaused: false)
                }
            }
        }
    }
    
    static private func createRotationAnimation(initialTransform: Transform) -> AnimationGroup {
        // First target: 1/3 of a full rotation (120°) about the y-axis.
        var transformTarget1 = initialTransform
        let rotation120 = simd_quatf(angle: 2 * Float.pi / 3, axis: SIMD3<Float>(0,1,0))
        transformTarget1.rotation = initialTransform.rotation * rotation120

        // Second target: 2/3 of a full rotation (another 120° from target1, total 240°)
        var transformTarget2 = transformTarget1
        transformTarget2.rotation = transformTarget1.rotation * rotation120
        

        // 2. Define the duration for each segment.
        let duration: TimeInterval = TimeInterval(Int.random(in: 3...7))

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
        return AnimationGroup(
            group: [rotateSegment1, rotateSegment2, rotateSegment3],
            repeatMode: .repeat
        )
        
    }
}


#Preview {
    Planets()
}
