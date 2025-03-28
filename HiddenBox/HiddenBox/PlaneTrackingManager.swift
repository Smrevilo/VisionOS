//
//  PlaneTrackingManager.swift
//  HiddenBox
//
//  Created by m1 on 28/03/2025.
//
import ARKit
import RealityKit
import SwiftUI

@Observable
class PlaneTrackingManager {
    let session = ARKitSession()
    let planeTracking = PlaneDetectionProvider()
    
    var contentEntity = Entity()
    private var planeEntities = [UUID: Entity]()
    
    var dataProvidersAreSupported: Bool {
        PlaneDetectionProvider.isSupported
    }
    
    var isReadyToRun: Bool {
        planeTracking.state == .initialized
    }
    
    func setupContentEntity() -> Entity {
        contentEntity
    }
    
    func monitorSessionEvents() async {
        for await event in session.events {
            switch event {
            case .authorizationChanged(type: _, status: let status):
                print("Authorization changed to: \(status)")
                if status == .denied {
                    print("ARKit authorization is denied by the user")
                }
            case .dataProviderStateChanged(dataProviders: let providers, newState: let state, error: let error):
                print("Data provider changed \(providers), \(state)")
                if let error {
                    print("Data provider reached an error state: \(error)")
                }
            @unknown default:
                fatalError("Unhandled new event type \(event)")
            }
        }
    }
    
    func runARKitSession() async {
        do {
            try await session.run([planeTracking])
        } catch {
            print("error starting arkit session: \(error.localizedDescription)")
        }
    }
    
    func processPlaneDetectionUpdates() async {
        for await anchorUpdate in planeTracking.anchorUpdates {
            let anchor = anchorUpdate.anchor
            
            if anchorUpdate.event == .removed {
                if let entity = planeEntities.removeValue(forKey: anchor.id) {
                    entity.removeFromParent()
                }
                return
            }
            let entity = Entity()
            entity.name = "Plane \(anchor.id)"
            entity.setTransformMatrix(anchor.originFromAnchorTransform, relativeTo: nil)
            
            var meshResource: MeshResource? = nil
            do {
                let contents = MeshResource.Contents(planeGeometry: anchor.geometry)
                meshResource = try MeshResource.generate(from: contents)
            } catch {
                print("Failed to create a mesh resource for a plane anchor: \(error)")
                return
            }
            
            var material = UnlitMaterial(color: .red)
            material.blending = .transparent(opacity: .init(floatLiteral: 0))
            
            if let meshResource {
                entity.components.set(ModelComponent(mesh: meshResource, materials: [material]))
            }
            
            var shape: ShapeResource? = nil
            do {
                let vertices = anchor.geometry.meshVertices.asSIMD3(ofType: Float.self)
                shape = try await ShapeResource.generateStaticMesh(positions: vertices, faceIndices: anchor.geometry.meshFaces.asUInt16Array())
            } catch {
                print("Failed to create a statich mesh for a plane anchor: \(error)")
                return
            }
            
            if let shape {
                entity.components.set(CollisionComponent(shapes: [shape], isStatic: true))
                let physics = PhysicsBodyComponent(mode: .static)
                entity.components.set(physics)
            }
            
            let existingEntity = planeEntities[anchor.id]
            planeEntities[anchor.id] = entity
            contentEntity.addChild(entity)
            existingEntity?.removeFromParent()
            
        }
    }
}
