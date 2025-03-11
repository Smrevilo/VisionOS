//
//  ChessApp.swift
//  Chess
//
//  Created by m1 on 11/03/2025.
//

import SwiftUI

@main
struct ChessApp: App {
    @Environment(\.dismissWindow) var dismissWindow
    
    private var initialVolumeSize = Size3D(width: 900, height: 500, depth: 900)
    private var initialWindowSize = CGSize(width: 1166, height: 860)

    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .onAppear {
                    dismissWindow(id: "Chessboard")
                }
        }
        .windowResizability(.contentMinSize)
        .defaultSize(initialWindowSize)
        
        
        
        
        WindowGroup(id: "Chessboard") {
            GameView()
        }
        .windowStyle(.volumetric)
        .defaultWorldScaling(.dynamic)
        .defaultSize(initialVolumeSize)
     }
}
