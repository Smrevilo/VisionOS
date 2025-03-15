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
    var body: some View {
        RealityView { content in
            guard let entity = try? await Entity(named: "Scene", in: realityKitContentBundle) else {
                fatalError("Unable to load scene model")
            }
            
            content.add(entity)
        }
    }
}

#Preview {
    CapsuleRealityArea()
        .environment(ViewModel())
}
