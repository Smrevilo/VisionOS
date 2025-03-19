//
//  HandTrackingViewModel.swift
//  VisionStack
//
//  Created by m1 on 19/03/2025.
//

import RealityKit
import SwiftUI
import ARKit
import RealityKitContent

@MainActor
@Observable
class HandTrackingViewModel {
    private let session = ARKitSession()
    private let handTracking = HandTrackingProvider()
    
    private let sceneReconstruction = SceneReconstructionProvider()
    
    private var contentEntity = Entity()
    
    private var meshEntities = [UUID : ModelEntity]()
    
    private var fingerEntities: [HandAnchor.Chirality: ModelEntity] = [.left: .createFingerTip(), .right: .createFingerTip()]
    
    private var lastCubePlacementTime: TimeInterval = 0
    
    func setupContentEntity() -> Entity {
        for entity in fingerEntities.values {
            contentEntity.addChild(entity)
        }
        
        return contentEntity
    }
}
