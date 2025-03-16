//
//  Areas.swift
//  Inspiration4App
//
//  Created by m1 on 13/03/2025.
//

import SwiftUI

struct Areas: View {
    @Environment(ViewModel.self) private var model
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.dismissWindow) private var dismissWindow
    
    
    var body: some View {
        ZStack {
            NavigationStack {
                NavigationToAreas()
            }
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            if ((model.isShowingFullRocket || model.isShowingMixedRocket) && newValue == .background) {
                Task {
                    await dismissImmersiveSpace()
                }
            }
            if model.isShowingRocketCapsule && newValue == .background {
                dismissWindow(id: model.capsuleRealityAreaId)
            }
        }
    }
}

#Preview {
    Areas()
}
