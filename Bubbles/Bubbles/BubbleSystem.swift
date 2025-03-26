//
//  BubbleSystem.swift
//  Bubbles
//
//  Created by m1 on 26/03/2025.
//
import RealityKit
import RealityKitContent

class BubbleSystem: System {
    private let query = EntityQuery(where: .has(BubbleComponent.self))
    private let speed: Float = 0.0001
    
    func update(context: SceneUpdateContext) {
        context.scene.performQuery(query).forEach { bubble in
            guard let bubbleComponent = bubble.components[BubbleComponent.self] else {return}
            bubble.position += bubbleComponent.direction * speed
            
        }
        
    }
    
    required init(scene: Scene) {
    }
}
