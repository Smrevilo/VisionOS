//
//  ContentView.swift
//  VisionTestApp
//
//  Created by m1 on 18/02/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var buttonText = "Hello, Vision Pro!"
    @State private var tapped = false
    
    var body: some View {
        Text(buttonText)
            .font(.largeTitle)
            .bold()
            .position(x: 400, y: 700)
        Button("Change Text") {
            buttonText = tapped ? "Hello, Vision Pro!" : "Button was tapped!"
            tapped = !tapped
            print("Button was TAPPED")
        }
    }
}

#Preview {
    ContentView()
}
