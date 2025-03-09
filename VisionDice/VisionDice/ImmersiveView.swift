//
//  ImmersiveView.swift
//  VisionDice
//
//  Created by m1 on 07/03/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {

    var body: some View {
        RealityView { content in
            if let diceModel = try? await Entity(named: "dice") {
                if let dice = diceModel.children.first?.children.first {
                    dice.scale = [0.1, 0.1, 0.1]
                    dice.position.y = 0.5
                    dice.position.z = -1
                    content.add(dice)
                }
            }
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
