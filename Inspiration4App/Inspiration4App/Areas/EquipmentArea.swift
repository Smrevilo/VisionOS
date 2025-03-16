//
//  EquimentArea.swift
//  Inspiration4App
//
//  Created by m1 on 15/03/2025.
//

import SwiftUI

struct EquipmentArea: View {
    @Environment(ViewModel.self) private var model
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    
    var body: some View {
        @Bindable var model = model
        
        HStack {
            EquipmentCard(isShowing: $model.isShowingRocketCapsule, imageName: "equipment-capsule", toggleTitle: "Rocket Capsule (Volumetric)") {
                openWindow(id: model.capsuleRealityAreaId)
            } dismissCard: {
                dismissWindow(id: model.capsuleRealityAreaId)
            }
            
            EquipmentCard(isShowing: $model.isShowingFullRocket, imageName: "equipment-fullrocket", toggleTitle: "Rocket (Full Immersive)") {
                await openImmersiveSpace(id: model.fullRocketRealityAreaId)
            } dismissCard: {
                await dismissImmersiveSpace()
            }
            
            EquipmentCard(isShowing: $model.isShowingMixedRocket, imageName: "equipment-mixedrocket", toggleTitle: "Rocket (Mixed Immersive)") {
                await openImmersiveSpace(id: model.mixedRocketRealityAreaId)
            } dismissCard: {
                await dismissImmersiveSpace()
            }
            
            
        }
    }
}

#Preview {
    EquipmentArea()
        .environment(ViewModel())
}
