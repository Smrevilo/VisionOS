//
//  ContentView.swift
//  WallArt
//
//  Created by m1 on 27/02/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Welcome to Trifork's art gallery")
                .font(.extraLargeTitle2)
        }
        .padding(50)
        .glassBackgroundEffect()
        .onAppear() {
            Task {
                await openImmersiveSpace(id: "ImmersiveSpace")
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
