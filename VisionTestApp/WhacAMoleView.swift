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
    @State private var sphereSize: Float = 0.5
    @State private var score: Int = 0
    
    
    var body: some View {
        VStack {
            Text("Score: \(score)")
                .font(.largeTitle)
                .bold()
                .padding()
            
            RealityView { content in
                let sphere = ModelEntity(mesh: .generateSphere(radius: sphereSize))
                sphere.position = spherePos
                sphere.generateCollisionShapes(recursive: true)
                sphere.components.set(InputTargetComponent())
                content.add(sphere)
                
                
            } update: { content in
                if let sphere = content.entities.first {
                    sphere.position = spherePos
                    sphere.transform.scale = SIMD3<Float>(repeating: sphereSize)
                    
                }
                
            }
            .gesture(TapGesture().targetedToAnyEntity().onEnded { _ in
                score += 1
                sphereSize = Float.random(in: 0.2 ... 0.5)
                spherePos = SIMD3<Float>(
                    Float.random(in: -0.5 ... 0.5),
                    Float.random(in: 0.5 ... 1.5),
                    -2
                )
                
            })
        }
        
    }
}

