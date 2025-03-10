//
//  ContentView.swift
//  VisionDice
//
//  Created by m1 on 10/03/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    var body: some View {
        VStack {
            
            Text("🎲")
                .foregroundStyle(.yellow)
                .font(.custom("Menlo", size: 100))
                .bold()
                .padding()

            ToggleImmersiveSpaceButton()
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
