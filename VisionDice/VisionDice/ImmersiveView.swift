//
//  ImmersiveView.swift
//  VisionDice
//
//  Created by m1 on 10/03/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {

    var body: some View {
        RealityView { content in
            let floor = ModelEntity(mesh: .generatePlane(width: 50, depth: 50), materials: [OcclusionMaterial()])
            floor.generateCollisionShapes(recursive: false)
            floor.components[PhysicsBodyComponent.self] = .init(massProperties: .default, mode: .static)
            content.add(floor)
            
            
            if let diceScene = try? await Entity(named: "dice") {
                if let dice = diceScene.children.first?.children.first {
                    dice.scale = [0.1, 0.1, 0.1]
                    dice.position.y = 0.5
                    dice.position.z = -1
                    
                    dice.generateCollisionShapes(recursive: false)
                    dice.components.set(InputTargetComponent())
                    dice.components[PhysicsBodyComponent.self] = .init(massProperties: .default,
                                                                       material: .generate(staticFriction: 0.8, dynamicFriction: 0.5, restitution: 0.1),
                                                                       mode: .dynamic)
                    dice.components[PhysicsMotionComponent.self] = .init()
                    
                    
                    
                    content.add(dice)
                }
            }
        }
        .gesture(dragGesture)
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
                value.entity.components[PhysicsBodyComponent.self]?.mode = .kinematic
            }
            .onEnded { value in
                value.entity.components[PhysicsBodyComponent.self]?.mode = .dynamic
            }
    }
    
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
