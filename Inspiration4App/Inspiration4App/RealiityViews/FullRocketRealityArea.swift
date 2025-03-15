//
//  FullRocketRealityArea.swift
//  Inspiration4App
//
//  Created by m1 on 15/03/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct FullRocketRealityArea: View {
    @State private var audioController: AudioPlaybackController?
    
    var body: some View {
        RealityView { content in
            guard let entity = try? await Entity(named: "Immersive", in: realityKitContentBundle) else {
                fatalError("Unable to load scene model")
            }
            
            let ambientAudioEntity = entity.findEntity(named: "AmbientAudio")
            
            guard let resource = try? await AudioFileResource(named: "/Root/AmbientAudio/Space_wav", from: "Immersive.usda", in: realityKitContentBundle) else { fatalError("Unable to find space.wav file")}
            
            audioController = ambientAudioEntity?.prepareAudio(resource)
            audioController?.play()
            
            content.add(entity)
        }
        .onDisappear {
            audioController?.stop()
        }
    }
}

#Preview {
    FullRocketRealityArea()
        .environment(ViewModel())
}
