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
    @Binding private var score: Int
    @Binding private var timeRemaning: Int
    
    var body: some View {
        RealityView { content in
            let sphere = ModelEntity(mesh: .generateSphere(radius: sphereSize))
            sphere.position = spherePos
            sphere.generateCollisionShapes(recursive: true)
            sphere.components.set(InputTargetComponent())
            content.add(sphere)
            
            let anchor = AnchorEntity(.head)
            let scoreText = createTextEntity(text: "Score: \(score) \nTime Remaining: \(timeRemaning)")
            
            scoreText.position = [0.0, 0.3, -1]
            scoreText.name = "scoreText"
            
            anchor.addChild(scoreText)
            content.add(anchor)
        } update: { content in
            if let sphere = content.entities.first {
                sphere.position = spherePos
                sphere.transform.scale = SIMD3<Float>(repeating: sphereSize)
            }
            
            if let anchor = content.entities.first(where: { $0 is AnchorEntity }) as? AnchorEntity,
                let textEntity = anchor.children.first(where: { $0.name == "scoreText" }) as? ModelEntity
            {
                updateTextEntity(textEntity, newText: "Score: \(score) \nTime Remaining: \(timeRemaning)")
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
    
    init(score: Binding<Int>, timeRemaning: Binding<Int>) {
        self._score = score
        self._timeRemaning = timeRemaning
    }
}

func createTextEntity(text: String) -> ModelEntity {
    let textMesh = MeshResource.generateText(
            text,
            extrusionDepth: 0.1, // Makes the text slightly 3D
            font: .systemFont(ofSize: 0.05), // Adjust size
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byWordWrapping
        )
    let material = SimpleMaterial(color: .white, isMetallic: false)
    let entity = ModelEntity(mesh: textMesh, materials: [material])
    entity.name = "scoreText"
        
    return entity
    
}

func updateTextEntity(_ entity: ModelEntity, newText: String) {
    let newMesh = MeshResource.generateText(
        newText,
        extrusionDepth: 0.01,
        font: .systemFont(ofSize: 0.1),
        containerFrame: .zero,
        alignment: .center,
        lineBreakMode: .byWordWrapping
    )
    
    if var modelComponent = entity.components[ModelComponent.self] {
            modelComponent.mesh = newMesh
            entity.components[ModelComponent.self] = modelComponent
    }
    
}
