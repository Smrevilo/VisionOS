//
//  ImmersiveView.swift
//  PortalBox
//
//  Created by m1 on 20/03/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let portalScene = try? await Entity(named: "PortalBoxScene", in: realityKitContentBundle) {
                content.add(portalScene)

                guard let box = portalScene.findEntity(named: "Box") else {fatalError()}
                
                box.position = [0, 0.75, -1.5]
                box.scale *= [1, 2, 1]
                
                //Make world 1
                let world1 = await createSkyBoxWorldEntity(texture: "skybox1")
                content.add(world1)
                
                let worldPortal1 = createPortal(target: world1)
                guard let anchor1 = portalScene.findEntity(named: "AnchorPortal_0") else {fatalError("Cannot find Anchor")}
                anchor1.addChild(worldPortal1)
                worldPortal1.transform.rotation = simd_quatf(angle: -(.pi / 2), axis: [1, 0, 0])
                
                //Make world 2
                let world2 = await createSkyBoxWorldEntity(texture: "skybox2")
                content.add(world2)
                
                let worldPortal2 = createPortal(target: world2)
                guard let anchor2 = portalScene.findEntity(named: "AnchorPortal_1") else {fatalError("Cannot find Anchor")}
                anchor2.addChild(worldPortal2)
                worldPortal2.transform.rotation = simd_quatf(angle: (.pi / 2), axis: [1, 0, 0])
                
                //Make world 3
                let world3 = await createSkyBoxWorldEntity(texture: "skybox3")
                content.add(world3)
                
                let worldPortal3 = createPortal(target: world3)
                guard let anchor3 = portalScene.findEntity(named: "AnchorPortal_2") else {fatalError("Cannot find Anchor")}
                anchor3.addChild(worldPortal3)
                worldPortal3.transform.rotation = simd_quatf(angle: -(.pi / 2), axis: [0, 0, 1])
                
                //Make world 4
                let world4 = await createSkyBoxWorldEntity(texture: "skybox4")
                content.add(world4)
                
                let worldPortal4 = createPortal(target: world4)
                guard let anchor4 = portalScene.findEntity(named: "AnchorPortal_3") else {fatalError("Cannot find Anchor")}
                anchor4.addChild(worldPortal4)
                worldPortal4.transform.rotation = simd_quatf(angle: (.pi / 2), axis: [0, 0, 1])
            }
        }
    }
    
    
    
    func createPortal(target: Entity) -> Entity {
        let portalMesh = MeshResource.generatePlane(width: 1, depth: 1)
        let portal = ModelEntity(mesh: portalMesh, materials: [PortalMaterial()])
        portal.components.set(PortalComponent(target: target))
        
        return portal
    }
    
    func createSkyBoxWorldEntity(texture: String) async -> Entity {
        let world = Entity()
        world.components.set(WorldComponent())
        
        guard let resource = try? await TextureResource(named: texture) else {fatalError("Unable to get find \(texture)")}
        var material = UnlitMaterial()
        material.color = .init(texture: .init(resource))
        
        let entity = Entity()
        entity.components.set(ModelComponent(mesh: .generateSphere(radius: 1000), materials: [material]))
        entity.scale *= .init(x: -1, y: 1, z: 1)
        
        world.addChild(entity)
        
        return world
        
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
