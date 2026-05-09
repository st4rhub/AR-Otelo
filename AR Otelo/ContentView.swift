//
//  ContentView.swift
//  AR Otelo
//
//  Created by Océane PIOCHE on 20/03/2026.
//

import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    
    // Creates a spin action
    // Parameters are the axis on which the object will rotate (X,Y,Z) = (0,1,2)
    // and the number of revolutions the object will do
    func createSpinAction(axis: Int, revolutions:Float) -> SpinAction{
        if (axis == 0){
            return SpinAction(revolutions: revolutions,
                                     localAxis: [1,0,0],
                                     timingFunction: .easeInOut,
                                     isAdditive: false)
        } else if (axis == 1){
            return SpinAction(revolutions: revolutions,
                                     localAxis: [0,1,0],
                                     timingFunction: .easeInOut,
                                     isAdditive: false)
        } else if (axis == 2){
            return SpinAction(revolutions: revolutions,
                                     localAxis: [0,0,1],
                                     timingFunction: .easeInOut,
                                     isAdditive: false)
        } else {
            print("Wrong axis input, should be 0, 1 or 2")
            return SpinAction(revolutions: revolutions,
                                     localAxis: [0,0,0],
                                     timingFunction: .easeInOut,
                                     isAdditive: false)
        }
    }
    
    // Handles the UI
    func makeUIView(context: Context) -> ARView {

        let arView = ARView(frame: .zero)
        
        // Text mesh properties
            // Variables that can be reused when we generate the text
        let materialVar = SimpleMaterial(color: .systemPink, roughness: 0, isMetallic: true)
        let depthVar: Float = 0.01
        let fontVar = UIFont.systemFont(ofSize: 0.1)
        let containerFrameVar = CGRect(x: -0.5, y: -1, width: 1, height: 1)
        let alignmentVar: CTTextAlignment = .center
        let lineBreakModeVar : CTLineBreakMode = .byWordWrapping
        
        //---------------------//
        
        // Text for Object 1 : group-1 image
        let textMeshResource : MeshResource = .generateText("Gruppe 1",
                                           extrusionDepth: depthVar,
                                           font: fontVar,
                                           containerFrame: containerFrameVar,
                                           alignment: alignmentVar,
                                           lineBreakMode: lineBreakModeVar)
        
        // Creates the actual entity from the properties defined above
        let textEntity = ModelEntity(mesh: textMeshResource, materials: [materialVar])
        // Create the image anchor that the text will be attached to
        let anchor = AnchorEntity(.image(group: "AR Resources",
                                          name: "group-1"))
        
        // Attach text entity to the anchor
        textEntity.setParent(anchor)
        // Add the anchor to the scene's list of anchors
        arView.scene.anchors.append(anchor)

        
        // Creating the billboard animation (= objects looks at camera then goes back to initial position)
        // A billboard component for the textentity.
        var billboardComponent = BillboardComponent()
        // Disable the billboard at the beginning by setting its blend factor to zero.
        billboardComponent.blendFactor = 0.0
        // Add the component to the entity
        textEntity.components.set(billboardComponent)
        // Create a transition that lasts one second
        let billboardTransition = BillboardAction.Transition(
            duration: 1.0,
            timingFunction: .easeInOut
        )
        // An action that starts and ends with a one second transition.
        let billboardAction = BillboardAction(transitionIn: billboardTransition,
                                              transitionOut: billboardTransition)
        let billboardAnimation = try! AnimationResource
            .makeActionAnimation(for: billboardAction,
                                 duration: 3.0,
                                 bindTarget: .billboardBlendFactor)


        // Play the three second billboard animation that adjusts the blend factor.
        textEntity.playAnimation(billboardAnimation)
        
        
        //---------------------//
        
        
        // Text for Object 2 : calm image
        let textMeshResource2 : MeshResource = .generateText("Ruhig",
                                           extrusionDepth: depthVar,
                                           font: fontVar,
                                           containerFrame: containerFrameVar,
                                           alignment: alignmentVar,
                                           lineBreakMode: lineBreakModeVar)
        
        // Create text entity with previous properties
        let textEntity2 = ModelEntity(mesh: textMeshResource2, materials: [materialVar])
        
        // Create image anchor that the text entity will be attached to
        let anchor2 = AnchorEntity(.image(group: "AR Resources",
                                          name: "calm"))
        // Attach text entity to image anchor
        textEntity2.setParent(anchor2)
        // Add image anchor to scene
        arView.scene.anchors.append(anchor2)

        // Create spin animation (1 revolution, on the Y axis)
        let spinAnimation2 = try! AnimationResource.makeActionAnimation(for: createSpinAction(axis: 1, revolutions: 1),
                                                                  duration: 2,
                                                                  bindTarget: .transform)

        // Attach the animation to the text
        textEntity2.playAnimation(spinAnimation2)
        
        //---------------------//

        // Text for Magic image
        let magicTextMeshResource : MeshResource = .generateText("Magie",
                                           extrusionDepth: depthVar,
                                           font: fontVar,
                                           containerFrame: containerFrameVar,
                                           alignment: alignmentVar,
                                           lineBreakMode: lineBreakModeVar)
        
        // Creates the actual entity from the properties defined above
        let textEntityMagic = ModelEntity(mesh: magicTextMeshResource, materials: [materialVar])
        // Create the image anchor that the text will be attached to
        let anchorMagic = AnchorEntity(.image(group: "AR Resources",
                                          name: "magic"))
        
        // Attach text entity to the anchor
        textEntityMagic.setParent(anchorMagic)
        // Add the anchor to the scene's list of anchors
        arView.scene.anchors.append(anchorMagic)

        
        // Create an action that gradually animates a float value
        // from '0.0' towards `1.0`, with a linear transition.
        let opacityAction = FromToByAction<Float>(from: 0.0,
                                                  to: 1.0,
                                                  timing: .linear,
                                                  isAdditive: false)


        // A five second animation that plays an animation causing the entity to
        // gradually animate the `.opacity` property towards `1.0`.
        //
        // This makes the entity fade-in.
        let opacityAnimation = try! AnimationResource
            .makeActionAnimation(for: opacityAction,
                                 duration: 5.0,
                                 bindTarget: .opacity)


        // Play the five second animation on the entity that will fade-out.
        textEntityMagic.playAnimation(opacityAnimation)
        
        //---------------------//
        
        // Text for Drown image
        let drownTextMeshResource : MeshResource = .generateText("Ertrinken",
                                           extrusionDepth: depthVar,
                                           font: fontVar,
                                           containerFrame: containerFrameVar,
                                           alignment: alignmentVar,
                                           lineBreakMode: lineBreakModeVar)
        
        // Creates the actual entity from the properties defined above
        let textEntityDrown = ModelEntity(mesh: drownTextMeshResource, materials: [materialVar])
        // Create the image anchor that the text will be attached to
        let anchorDrown = AnchorEntity(.image(group: "AR Resources",
                                          name: "hey-drown"))
        
        // Attach text entity to the anchor
        textEntityDrown.setParent(anchorDrown)
        // Add the anchor to the scene's list of anchors
        arView.scene.anchors.append(anchorDrown)

        // CREATING ANIMATION :
        // Create a transform to start animating from.
        let startTransform = Transform(translation: [0.0, 2.0, 0.0])


        // Create a transform to animate towards.
        let endTransform = Transform(translation: [0.0, -2.0, 0.0])


        // Create an action that gradually animates a transform value.
        //
        // This starts `from` a specified value, and animates towards
        // a specified `to` value.
        //
        // The bound entity will move in the space relative to its parent (from up to down).
        let drownAction = FromToByAction<Transform>(from: startTransform,
                                                        to: endTransform,
                                                        mode: .parent,
                                                        timing: .linear,
                                                        isAdditive: false)


        // A five second animation that plays an animation causing
        // the entity to gradually move from a specific start, and end transform
        let drownAnimation = try! AnimationResource
            .makeActionAnimation(for: drownAction,
                                 duration: 5.0,
                                 bindTarget: .transform)


        // Play the five second animation on the entity that will cause it to move.
        textEntityDrown.playAnimation(drownAnimation)
        
        //---------------------//
        
        // Text for Fly image
        let flyTextMeshResource : MeshResource = .generateText("Fliegen",
                                           extrusionDepth: depthVar,
                                           font: fontVar,
                                           containerFrame: containerFrameVar,
                                           alignment: alignmentVar,
                                           lineBreakMode: lineBreakModeVar)
        
        // Creates the actual entity from the properties defined above
        let textEntityFly = ModelEntity(mesh: flyTextMeshResource, materials: [materialVar])
        // Create the image anchor that the text will be attached to
        let anchorFly = AnchorEntity(.image(group: "AR Resources",
                                          name: "fly"))
        
        // Attach text entity to the anchor
        textEntityFly.setParent(anchorFly)
        // Add the anchor to the scene's list of anchors
        arView.scene.anchors.append(anchorFly)

        // CREATING ANIMATION :
        // Create a transform to start animating from.
        let startTransformFly = Transform(translation: [0.0, -2.0, 0.0])


        // Create a transform to animate towards.
        let endTransformFly = Transform(translation: [0.0, 2.0, 0.0])


        // Create an action that gradually animates a transform value.
        //
        // This starts `from` a specified value, and animates towards
        // a specified `to` value.
        //
        // The bound entity will move in the space relative to its parent (from down to up).
        let flyAction = FromToByAction<Transform>(from: startTransformFly,
                                                        to: endTransformFly,
                                                        mode: .parent,
                                                        timing: .easeIn,
                                                        isAdditive: false)


        // A five second animation that plays an animation causing
        // the entity to gradually move from a specific start, and end transform
        let flyAnimation = try! AnimationResource
            .makeActionAnimation(for: flyAction,
                                 duration: 5.0,
                                 bindTarget: .transform)


        // Play the five second animation on the entity that will cause it to move.
        textEntityFly.playAnimation(flyAnimation)
        
        //---------------------//
        
        // Text for dance image
        let danceTextMeshResource : MeshResource = .generateText("Tanzen",
                                           extrusionDepth: depthVar,
                                           font: fontVar,
                                           containerFrame: containerFrameVar,
                                           alignment: alignmentVar,
                                           lineBreakMode: lineBreakModeVar)
        
        // Creates the actual entity from the properties defined above
        let textEntityDance = ModelEntity(mesh: danceTextMeshResource, materials: [materialVar])
        // Create the image anchor that the text will be attached to
        let anchorDance = AnchorEntity(.image(group: "AR Resources",
                                          name: "dance"))
        
        // Attach text entity to the anchor
        textEntityDance.setParent(anchorDance)
        // Add the anchor to the scene's list of anchors
        arView.scene.anchors.append(anchorDance)

        // CREATING ANIMATION :
        // Create spin animation (5 revolutions, on the Y axis)
        let spinAnimationDance = try! AnimationResource.makeActionAnimation(for: createSpinAction(axis: 1, revolutions: 5),
                                                                  duration: 5,
                                                                  bindTarget: .transform)

        // Attach the animation to the text
        textEntityDance.playAnimation(spinAnimationDance)
        
        //---------------------//
        
        // Text for proud image
        let proudTextMeshResource : MeshResource = .generateText("Stolz",
                                           extrusionDepth: depthVar,
                                           font: fontVar,
                                           containerFrame: containerFrameVar,
                                           alignment: alignmentVar,
                                           lineBreakMode: lineBreakModeVar)
        
        // Creates the actual entity from the properties defined above
        let textEntityProud = ModelEntity(mesh: proudTextMeshResource, materials: [materialVar])
        // Create the image anchor that the text will be attached to
        let anchorProud = AnchorEntity(.image(group: "AR Resources",
                                          name: "proud"))
        
        // Attach text entity to the anchor
        textEntityProud.setParent(anchorProud)
        // Add the anchor to the scene's list of anchors
        arView.scene.anchors.append(anchorProud)

        // CREATING ANIMATION :
        // Create a transform to animate towards.
        let endScaleByProud = Transform(scale: [2,2,2])


        // Create an action that gradually animates a transform value.
        //
        // The bound entity will move in the space relative to its parent (double in size).
        let transformActionProud = FromToByAction<Transform>(to: endScaleByProud,
                                                        mode: .parent,
                                                        timing: .easeOut,
                                                        isAdditive: false)


        // A five second animation that plays an animation causing
        // the entity to gradually move from a specific start, and end transform
        let transformAnimationProud = try! AnimationResource
            .makeActionAnimation(for: transformActionProud,
                                 duration: 2.0,
                                 bindTarget: .transform)


        // Play the five second animation on the entity that will cause it to move.
        textEntityProud.playAnimation(transformAnimationProud)
        
        return arView
    }
    func updateUIView(_ uiView: ARView, context: Context) { }
}

struct ContentView: View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
