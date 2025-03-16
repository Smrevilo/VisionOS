//
//  EquipmentCard.swift
//  Inspiration4App
//
//  Created by m1 on 16/03/2025.
//

import SwiftUI

struct EquipmentCard: View {
    @Binding var isShowing : Bool
    let imageName : String
    let toggleTitle : String
    let openCard: () async -> Void
    let dismissCard: () async -> Void
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .frame(width: 300, height: 300)
                .padding(20)
            
            Toggle(isShowing ? "Hide \(toggleTitle)" : "Show \(toggleTitle)", isOn: $isShowing)
                .onChange(of: isShowing) { _, isShowing in
                    Task {
                        if isShowing {
                            await openCard()
                        } else {
                            await dismissCard()
                        }
                    }
                }
                .toggleStyle(.button)
                .padding(25)
        }
        .glassBackgroundEffect()
    }
}
