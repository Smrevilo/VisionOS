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
    
    @State private var inputText = ""
    @State public var showTextField = false
    
    @State private var assistant: Entity? = nil
    @State private var waveAnimation: AnimationResource? = nil
    
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
                
                guard let idleAnimationResource = assitant.availableAnimations.first else {return}
                guard let waveAnimatonResource = waveModel.availableAnimations.first else {return}
                
                
                
                let waveAnimation = try AnimationResource.sequence(with: [waveAnimatonResource, idleAnimationResource.repeat()])
                
                assitant.playAnimation(idleAnimationResource.repeat())
                
                Task {
                    self.assistant = assitant
                    self.waveAnimation = waveAnimation
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
                break
            case .updateWallart:
                break
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
