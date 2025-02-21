//
//  WhacAMoleView.swift
//  VisionTestApp
//
//  Created by m1 on 20/02/2025.
//

import SwiftUI
import RealityKit

struct WhacAMoleView: View {
    @State private var spherePos: SIMD3<Float> = [0, 2, -2]
    
    var body: some View {
        RealityView{ content in
            let sphere = ModelEntity(mesh: .generateSphere(radius: 0.5))
            sphere.position = spherePos
            sphere.generateCollisionShapes(recursive: true)
            sphere.components.set(InputTargetComponent())
            content.add(sphere)
            
            
        } update: { content in
            if let sphere = content.entities.first {
                sphere.position = spherePos
            }
            
        }
        .gesture(TapGesture().targetedToAnyEntity().onEnded { _ in
            spherePos = SIMD3<Float>(
                Float.random(in: -0.5 ... 0.5),
                Float.random(in: 0.5 ... 1.5),
                -2
            )
            
        })
        
        
        
    }
}

