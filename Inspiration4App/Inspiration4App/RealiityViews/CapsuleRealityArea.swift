//
//  CapsuleRealityArea.swift
//  Inspiration4App
//
//  Created by m1 on 15/03/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct CapsuleRealityArea: View {
    @Environment(ViewModel.self) private var model
    @State private var capsule : Entity?
    
    let attachmentId = "attachmentId"
    
    var body: some View {
        RealityView { content, attachments in
            guard let entity = try? await Entity(named: "Scene", in: realityKitContentBundle) else {
                fatalError("Unable to load scene model")
            }
            
            content.add(entity)
            self.capsule = entity
            self.capsule?.components.set(OrbitComponent(radius: 0.05, speed: 0, angle: 0, addOrientationRotation: true))
            
            if let sceneAttachments = attachments.entity(for: attachmentId) {
                sceneAttachments.position = SIMD3<Float>(-0.2, -0.1, 0.1)
                sceneAttachments.transform.rotation = simd_quatf(angle: -0.5, axis: [1,0,0])
                content.add(sceneAttachments)
            }
            
            content.add(entity)
        } update: { content, attachments in
            print("RealityView changes detected")
        } placeholder: {
            ProgressView()
                .progressViewStyle(.circular)
                .controlSize(.large)
        } attachments: {
            Attachment(id: attachmentId) {
                CapsuleDetails {
                    capsule?.setSunlight(intensity: 12)
                } turnOffLight: {
                    capsule?.setSunlight(intensity: 6)
                } turnOnOrbit: {
                    self.capsule?.components[OrbitComponent.self]?.speed = 1
                } turnOffOrbit: {
                    self.capsule?.components[OrbitComponent.self]?.speed = 0
                }
            }
        }
        .onDisappear() {
            model.isShowingRocketCapsule = false
        }
    }
}

#Preview {
    CapsuleRealityArea()
        .environment(ViewModel())
}
