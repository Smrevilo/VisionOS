//
//  ContentView.swift
//  Chess
//
//  Created by m1 on 11/03/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    @Environment(\.openWindow) var openWindow

    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)
            
            Button("Start Game") {
                Task {
                    openWindow(id: "Chessboard")
                }
            }

            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}

