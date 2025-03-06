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
        GeometryReader { geometry in
            ZStack {
                // Full-screen background.
                Color.black.ignoresSafeArea()

                // Centered content (text and button).
                VStack {
                    Text("Hello, world!")
                        .font(.largeTitle)
                    Button("Open Solar System") {
                        Task {
                            await openImmersiveSpace(id: "saturn")
                        }
                    }
                }
                .padding()
                .zIndex(1)

                // Image pinned to the bottom.
                VStack {
                    Spacer()
                    Image("Earth")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width,
                               height: geometry.size.height / 2,
                               alignment: .top)
                        .clipped()
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}


#Preview(windowStyle: .automatic) {
    ContentView()
}
