//
//  OrbitSystem.swift
//  Inspiration4App
//
//  Created by m1 on 18/03/2025.
//
import RealityKit

struct OrbitComponent : Component {
    var radius : Float
    var speed : Float
    var angle : Float
    var addOrientationRotation : Bool
    
    init(radius: Float = 2.0, speed: Float = 1.0, angle: Float, addOrientationRotation: Bool = false) {
        self.radius = radius
        self.speed = speed
        self.angle = angle
        self.addOrientationRotation = addOrientationRotation
    }
}

struct OrbitSystem : System {
    static let query = EntityQuery(where: .has(OrbitComponent.self))
    public init(scene: RealityKit.Scene) {
        
    }
    
    func setOrientation(context: SceneUpdateContext, entity: Entity, component: OrbitComponent) {
        entity.setOrientation(.init(angle: component.speed * Float(context.deltaTime), axis: [0, 1, 0]), relativeTo: entity)
    }
    
    func update(context: SceneUpdateContext) {
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
            if var component: OrbitComponent = entity.components[OrbitComponent.self] {
                if component.radius == 0 {
                    setOrientation(context: context, entity: entity, component: component)
                } else {
                    if component.addOrientationRotation {
                        setOrientation(context: context, entity: entity, component: component)
                    }
                    
                    let x = component.radius * cos(component.angle)
                    let z = component.radius * sin(component.angle)
                    
                    entity.transform.translation = SIMD3(x,0,z)
                    
                    component.angle += component.speed * Float(context.deltaTime)
                    
                    entity.components.set(component)
                }
            }
        }
    }
}

