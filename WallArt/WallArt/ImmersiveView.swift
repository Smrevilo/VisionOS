//
//  ImmersiveView.swift
//  WallArt
//
//  Created by m1 on 27/02/2025.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Combine

struct ImmersiveView: View {
    
    @Environment(AppModel.self) private var appModel
    @Environment(\.openWindow) private var openWindow
    
    @State private var projectile: Entity? = nil
    
    @State private var inputText = ""
    @State public var showTextField = false
    
    @State private var assistant: Entity? = nil
    @State private var waveAnimation: AnimationResource? = nil
    @State private var jumpAnimation: AnimationResource? = nil
    
    @State public var showAttachmentButtons = false
    
    let tapSubject = PassthroughSubject<Void, Never>()
    @State var cancellable: AnyCancellable?
    
    @State var characterEntity: Entity = {
        let headAnchor = AnchorEntity(.head)
        headAnchor.position = [0.7, -0.35, -1]
        let radians = -30 * Float.pi / 180
        ImmersiveView.rotateEntityAroundYAxis(entity: headAnchor, angle: radians)
        return headAnchor
    }()
    
    @State var planeEntity: Entity = {
        let wallAnchor = AnchorEntity(.plane(.vertical, classification: .wall, minimumBounds: SIMD2<Float>(0.6, 0.6)))
        let planeMesh = MeshResource.generatePlane(width: 3.75, depth: 2.625, cornerRadius: 0.1)
        let material = ImmersiveView.loadImageMaterial(imageUrl: "think_different")
        let planeEntity = ModelEntity(mesh: planeMesh, materials: [material])
        planeEntity.name = "canvas"
        wallAnchor.addChild(planeEntity)
        
        return wallAnchor
    }()

    var body: some View {
        RealityView { content, attachments in
            do {
                let immersiveContentEntity = try await Entity(named: "Immersive", in: realityKitContentBundle)
                characterEntity.addChild(immersiveContentEntity)
                content.add(characterEntity)
                content.add(planeEntity)
                
                // Get the attachment entity from the attachments parameter.
                guard let attachmentEntity = attachments.entity(for: "attachment") else { return }
                attachmentEntity.position = SIMD3<Float>(0, 0.62, 0)
                let radians = 30 * Float.pi / 180
                ImmersiveView.rotateEntityAroundYAxis(entity: attachmentEntity, angle: radians)
                characterEntity.addChild(attachmentEntity)
                
                let characterAnimationSceneEntity = try await Entity(named: "CharacterAnimations", in: realityKitContentBundle)
                
                guard let waveModel = characterAnimationSceneEntity.findEntity(named: "wave_model") else {return}
                guard let assitant = characterEntity.findEntity(named: "assistant") else {return}
                
                guard let jumpUpModel = characterAnimationSceneEntity.findEntity(named: "jump_up_model") else {return}
                guard let jumpFloatModel = characterAnimationSceneEntity.findEntity(named: "jump_float_model") else {return}
                guard let jumpDownModel = characterAnimationSceneEntity.findEntity(named: "jump_down_model") else {return}
                
                let projectileSceneEntity = try await Entity(named: "MainParticle", in: realityKitContentBundle)
                guard let projectile = projectileSceneEntity.findEntity(named: "ParticleRoot") else {return}
                projectile.children[0].components[ParticleEmitterComponent.self]?.isEmitting = false
                projectile.children[1].components[ParticleEmitterComponent.self]?.isEmitting = false
                projectile.components.set(ProjectileComponent())
                characterEntity.addChild(projectile)
                
                let impactParticleSceneEntity = try await Entity(named: "ImpactParticle", in: realityKitContentBundle)
                guard let impactParticle = impactParticleSceneEntity.findEntity(named: "ImpactParticle") else {return}
                impactParticle.position = [0, 0, 0]
                impactParticle.components[ParticleEmitterComponent.self]?.burstCount = 500
                impactParticle.components[ParticleEmitterComponent.self]?.emitterShapeSize.x = 3.75 / 2.0
                impactParticle.components[ParticleEmitterComponent.self]?.emitterShapeSize.z = 2.625 / 2.0
                planeEntity.addChild(impactParticle)
                
                
                guard let idleAnimationResource = assitant.availableAnimations.first else {return}
                guard let waveAnimatonResource = waveModel.availableAnimations.first else {return}
                
                guard let jumpUpAnimationResource = jumpUpModel.availableAnimations.first else {return}
                guard let jumpFloatAnimationResource = jumpFloatModel.availableAnimations.first else {return}
                guard let jumpDownAnimationResource = jumpDownModel.availableAnimations.first else {return}
                
                let jumpAnimation = try AnimationResource.sequence(with: [jumpUpAnimationResource, jumpFloatAnimationResource, jumpDownAnimationResource, idleAnimationResource.repeat()])
                
                
                let waveAnimation = try AnimationResource.sequence(with: [waveAnimatonResource, idleAnimationResource.repeat()])
                
                assitant.playAnimation(idleAnimationResource.repeat())
                
                Task {
                    self.assistant = assitant
                    self.waveAnimation = waveAnimation
                    self.jumpAnimation = jumpAnimation
                    self.projectile = projectile
                }
                
            } catch {
                print("Error in realityView's make: \(error)")
            }
        } attachments: {
            Attachment(id: "attachment") {
                VStack {
                    Text(inputText)
                        .frame(maxWidth: 600, alignment: .leading)
                        .font(.extraLargeTitle2)
                        .fontWeight(.regular)
                        .padding(40)
                        .glassBackgroundEffect()
                    
                    if showAttachmentButtons {
                        HStack(spacing: 20) {
                            Button(action: {
                                tapSubject.send()
                            }) {
                                Text("Yes, let's go!")
                                    .font(.largeTitle)
                                    .fontWeight(.regular)
                                    .padding()
                                    .cornerRadius(8)
                            }
                            .padding()
                            .buttonStyle(.bordered)
                            
                            Button(action: {
                                
                            }) {
                                Text("No")
                                    .font(.largeTitle)
                                    .fontWeight(.regular)
                                    .padding()
                                    .cornerRadius(8)
                            }
                            .padding()
                            .buttonStyle(.bordered)
                        }
                        .glassBackgroundEffect()
                        .opacity(showAttachmentButtons ? 1 : 0)
                        
                    }
                }
                .opacity(showTextField ? 1 : 0)
            }
        }
        .gesture(SpatialTapGesture().targetedToAnyEntity().onEnded { _ in
            appModel.flowState = .intro
        })
        .onChange(of: appModel.flowState) { _, newValue in
            switch newValue {
            case .idle:
                break
            case .intro:
                playIntroSequence()
            case .projectileFlying:
                if let projectile = self.projectile {
                    let dest = Transform(scale: projectile.transform.scale, rotation: projectile.transform.rotation, translation: [-0.7, 0.15, -0.5]*2)
                    Task {
                        let duration = 3.0
                        projectile.position = [0, 0.1, 0]
                        projectile.children[0].components[ParticleEmitterComponent.self]?.isEmitting = true
                        projectile.children[1].components[ParticleEmitterComponent.self]?.isEmitting = true
                        projectile.move(to: dest, relativeTo: self.characterEntity, duration: duration, timingFunction: .easeInOut)
                        try? await Task.sleep(for: .seconds(duration))
                        projectile.children[0].components[ParticleEmitterComponent.self]?.isEmitting = false
                        projectile.children[1].components[ParticleEmitterComponent.self]?.isEmitting = false
                        appModel.flowState = .updateWallart
                    }
                }
                
            case .updateWallart:
                self.projectile?.components[ProjectileComponent.self]?.canBurst = true
                if let plane = planeEntity.findEntity(named: "canvas") as? ModelEntity {
                    plane.model?.materials = [ImmersiveView.loadImageMaterial(imageUrl: "sketch")]
                }
                
                if let assistant = self.assistant, let jumpAnimation = self.jumpAnimation {
                    Task {
                        try? await Task.sleep(for: .milliseconds(500))
                        assistant.playAnimation(jumpAnimation)
                        await animatePromptText(text: "Awesome")
                        try? await Task.sleep(for: .milliseconds(500))
                        await animatePromptText(text: "What else do you want to see us build in Vision Pro")
                    }
                }
            }
        }
    }
    
    func animatePromptText(text: String) async {
        inputText = ""
        let words = text.split(separator: " ")
        for word in words {
            inputText.append(word + " ")
            let milliseconds = (1 + UInt64 .random(in: 0 ... 1)) * 100
            try? await Task.sleep(for: .milliseconds(milliseconds))
        }
    }
    
    func waitForButtonTap(using buttonTapPublisher: PassthroughSubject<Void, Never>) async {
        await withCheckedContinuation { continuation in
            let cancellable = tapSubject.first().sink { _ in
                continuation.resume()
            }
            self.cancellable = cancellable
        }
    }
    
    func playIntroSequence() {
        Task {
            if !showTextField {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showTextField.toggle()
                }
            }
            if let assistant = self.assistant, let waveAnimation = self.waveAnimation {
                assistant.playAnimation(waveAnimation.repeat(count: 1))
            }
            
            let texts = [
                "Hey :) Let's create some doodle art with the Vision Pro Are you Ready?",
                "Awesome. Draw something and watch it come alive"
            ]
            
            await animatePromptText(text: texts[0])
            
            withAnimation(.easeInOut(duration: 0.3)) {
                showAttachmentButtons = true
            }
            
            await waitForButtonTap(using: tapSubject)
            
            withAnimation(.easeInOut(duration:0.3)) {
                showAttachmentButtons = false
            }
                          
            Task {
                await animatePromptText(text: texts[1])
            }
            
            DispatchQueue.main.async {
                openWindow(id: "doodle_canvas")
            }
        }
    }

    
    static func rotateEntityAroundYAxis(entity: Entity, angle: Float) {
        //Get the transform of the input entity
        var currentTransform = entity.transform
        
        //Get a quaternion representing a rotation around the Y-axis
        let rotation = simd_quatf(angle: angle, axis: [0, 1, 0])
        
        //combine the transformation with the current transformation
        currentTransform.rotation = rotation * currentTransform.rotation
        
        // apply the new transformation to the entity
        entity.transform = currentTransform
    }
    
    static func loadImageMaterial(imageUrl: String) -> SimpleMaterial {
        do {
            let texture = try TextureResource.load(named: imageUrl)
            var material = SimpleMaterial()
            let color = SimpleMaterial.BaseColor(texture: MaterialParameters.Texture(texture))
            material.color = color
            return material
            
        } catch {
            fatalError(String(describing: error))
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
