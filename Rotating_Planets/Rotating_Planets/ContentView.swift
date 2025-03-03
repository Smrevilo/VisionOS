//
//  ContentView.swift
//  Rotating_Planets
//
//  Created by m1 on 03/03/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace

    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Hello, world!")
            
            Button("Open Saturn") {
                Task {
                    await openImmersiveSpace(id: "saturn")
                }
                
            }

        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
