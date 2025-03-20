//
//  StackingView.swift
//  VisionStack
//
//  Created by m1 on 19/03/2025.
//

import SwiftUI
import RealityKit

struct StackingView: View {
    @State var model = HandTrackingViewModel()
    
    var body: some View {
        RealityView { content in
            content.add(model.setupContentEntity())
            
        }.task {
            await model.runSession()
        }.task {
            // process our hand updates
        }.task {
            // process our world reconstruction
        }.gesture(SpatialTapGesture().targetedToAnyEntity().onEnded({ value in
            
            Task {
                // Place our cube
            }
        }))
    }
}

#Preview {
    StackingView()
}
