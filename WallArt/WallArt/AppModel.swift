//
//  AppModel.swift
//  WallArt
//
//  Created by m1 on 27/02/2025.
//

import SwiftUI
import Foundation

enum FlowState {
    case idle
    case intro
    case projectileFlying
    case updateWallart
}


@Observable
class AppModel {
    var flowState = FlowState.idle
}
