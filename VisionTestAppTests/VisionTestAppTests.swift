//
//  VisionTestAppTests.swift
//  VisionTestAppTests
//
//  Created by m1 on 18/02/2025.
//

import Testing
import SwiftUI
import RealityKit
@testable import VisionTestApp

struct VisionTestAppTests {

    @Test func testMoleAppearsInScene() {
        let view = WhacAMoleView()
        let realityView = try await extractRealityView(from: view)
        
        let hasMole = realityView.entities.contains {
            entity in
            entity is ModelEntity
        }
        
        #expect(hasMole, "Mole Should be present in scene")
        
    }
}
