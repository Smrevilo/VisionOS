//
//  ImpactParticleSystem.swift
//  WallArt
//
//  Created by m1 on 03/03/2025.
//

import RealityKit


struct ProjectileComponent: Component, Codable {
    public var bursted = false
    public var canBurst = false
}

struct ImpactParticleSystem: System {
    
    static let projectileQuery = EntityQuery(where: .has(ProjectileComponent.self))
    static let particleQuery = EntityQuery(where: .has(ParticleEmitterComponent.self))
    
    init(scene: Scene) {}
    
    func update(context: SceneUpdateContext) {
        var iter = context.entities(matching: ImpactParticleSystem.projectileQuery, updatingSystemWhen: .rendering).makeIterator()
        
        guard let projectile = iter.next() else {return}
        guard var projectileComponent = projectile.components[ProjectileComponent.self] else {return}
        
        if !projectileComponent.bursted && projectileComponent.canBurst {
            for p in context.entities(matching: ImpactParticleSystem.particleQuery, updatingSystemWhen: .rendering) {
                if p.name == "ImpactParticle" {
                    p.components[ParticleEmitterComponent.self]?.burst()
                }
            }
            projectileComponent.bursted = true
            projectile.components[ProjectileComponent.self] = projectileComponent
        }
    }
}
