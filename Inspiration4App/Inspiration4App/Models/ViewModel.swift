//
//  ViewModel.swift
//  Inspiration4App
//
//  Created by m1 on 13/03/2025.
//

import Foundation

@Observable
class ViewModel {
    var navigationPath: [Area] = []
    var isShowingRocketCapsule: Bool = false
    var isShowingFullRocket: Bool = false
    var isShowingMixedRocket: Bool = false
    
    var capsuleRealityAreaId: String = "CapsuleRealityArea"
    var fullRocketRealityAreaId: String = "FullRocketRealityArea"
    var mixedRocketRealityAreaId: String = "MixedRocketRealityArea"
}
