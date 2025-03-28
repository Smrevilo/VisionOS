//
//  ImmersiveView.swift
//  HiddenBox
//
//  Created by m1 on 27/03/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Combine

struct ImmersiveView: View {
    
    @State private var boxTopLeft = Entity()
    @State private var boxTopRight = Entity()
    @State private var boxTopCollision = Entity()
    @State private var openBoxEmitter = Entity()
    
    @State private var isBoxOpen = false
    
    @State private var animationCompleteSubscription: AnyCancellable?
    
    init() {
        ToyComponent.registerComponent()
    }

    var body: some View {
        RealityView { content in
            let anchor = AnchorEntity(.plane(.horizontal, classification: .table, minimumBounds: [0.5,0.5]))
            content.add(anchor)
            
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                anchor.addChild(immersiveContentEntity)
                
                immersiveContentEntity.position.y = -0.25
                
                if let boxTopLeft = immersiveContentEntity.findEntity(named: "TopLeft_Occlusion"),
                   let boxTopRight = immersiveContentEntity.findEntity(named: "TopRight_Occlusion"),
                   let boxTopCollision = immersiveContentEntity.findEntity(named: "TopCollision"),
                   let openBoxEmitter = immersiveContentEntity.findEntity(named: "OpenParticleEmitter"){
                    self.boxTopLeft = boxTopLeft
                    self.boxTopRight = boxTopRight
                    self.boxTopCollision = boxTopCollision
                    self.openBoxEmitter = openBoxEmitter
                } else {
                    print("faiil")
                }

            }
        }
        .gesture(SpatialTapGesture().targetedToEntity(boxTopCollision).onEnded({ value in
            self.playOpenBoxAnimation()
        }))
        .gesture(DragGesture()
            .targetedToEntity(where: .has(ToyComponent.self))
            .onChanged({ value in
            value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
                value.entity.components[PhysicsBodyComponent.self] = .none
        })
                .onEnded({ value in
                    let material = PhysicsMaterialResource.generate(friction: 0.8, restitution: 0.0)
                    let pb = PhysicsBodyComponent(material: material)
                    value.entity.components.set(pb)
                }))
    }
    
    func playOpenBoxAnimation() {
        guard !isBoxOpen else {return}
        isBoxOpen.toggle()
        
        var leftTransform = boxTopLeft.transform
        var rightTransform = boxTopRight.transform
        
        leftTransform.translation += [-0.25,0,0]
        rightTransform.translation += [0.25,0,0]
        
        boxTopLeft.move(to: leftTransform, relativeTo: boxTopLeft.parent, duration: 3, timingFunction: .easeInOut)
        boxTopRight.move(to: rightTransform, relativeTo: boxTopRight.parent, duration: 3, timingFunction: .easeInOut)
        
        animationCompleteSubscription = boxTopLeft.scene?.publisher(for: AnimationEvents.PlaybackCompleted.self, on: boxTopLeft).sink { _ in
            boxTopLeft.removeFromParent()
            boxTopRight.removeFromParent()
            boxTopCollision.removeFromParent()
            
            if var particleEmitter = openBoxEmitter.components[ParticleEmitterComponent.self] {
                particleEmitter.isEmitting = true
                openBoxEmitter.components[ParticleEmitterComponent.self] = particleEmitter
            }
            
            self.animationCompleteSubscription = nil
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
