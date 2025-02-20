//
//  ImmersiveView.swift
//  VisionTestApp
//
//  Created by m1 on 20/02/2025.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            let sphere = ModelEntity(mesh: .generateSphere(radius: 0.2))
            sphere.position = [0, 5, -10]
            content.add(sphere)
            
        }
    }
}

