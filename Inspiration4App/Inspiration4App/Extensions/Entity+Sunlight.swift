//
//  Entity+Sunlight.swift
//  Inspiration4App
//
//  Created by m1 on 17/03/2025.
//

import RealityKit

extension Entity {
    func setSunlight(intensity: Float?) {
        if let intensity {
            Task {
                guard let resource = try? await EnvironmentResource(named: "Sunlight")  else {
                    print("Sunlight not found")
                    return
                }
                
                let iblComponent = ImageBasedLightComponent(source: .single(resource), intensityExponent: intensity)
                
                components.set(iblComponent)
                components.set(ImageBasedLightReceiverComponent(imageBasedLight: self))
            }
        } else {
            components.remove(ImageBasedLightComponent.self)
            components.remove(ImageBasedLightReceiverComponent.self)
        }
    }
}
