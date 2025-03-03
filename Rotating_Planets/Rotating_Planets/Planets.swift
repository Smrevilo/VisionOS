//
//  Planets.swift
//  Rotating_Planets
//
//  Created by m1 on 03/03/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct Planets: View {
    @Environment(\.dismissWindow) var dismissWindow
    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "Planets", in: realityKitContentBundle) {
                content.add(scene)
            }
           
        }
        .gesture(TapGesture().targetedToAnyEntity().onEnded({
            value in
            let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                var transform = value.entity.transform
                
                let radians = Float.pi / 2
                let rot = simd_quatf(angle: radians, axis: SIMD3<Float>(1,0,0))
                transform.rotation *= rot
                
                
                value.entity.move(to: transform, relativeTo: nil,
                                  duration: 3, timingFunction: .linear)
            }
            
            timer.fire()
            
        }))
        .onAppear() {
            dismissWindow(id: "main")
        }
    }
}


#Preview {
    Planets()
}
