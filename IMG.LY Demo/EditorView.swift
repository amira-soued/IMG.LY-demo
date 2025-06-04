//
//  EditorView.swift
//  IMG.LY Demo
//
//  Created by Amira Soued on 04/06/2025.
//

import SwiftUI
import IMGLYPhotoEditor
import IMGLYDesignEditor
import IMGLYEngine

struct EditorView : View {
    @State var item: SceneModel?
    var engineSettings = EngineSettings(license: "ij_CRCIwzhd9DzenrjUUn1YDwbMeAckxvjTDvrRbqHj6gelNUhvTTauAPpM2KQRk")
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        DesignEditor(engineSettings)
            // add crop to square button
            .imgly.modifyInspectorBarItems{ context,items in
                items.addAfter(id: InspectorBar.Buttons.ID.crop) {
                    InspectorBar.Button(id: "cropSquare") { context in
                        do {
                            let selectedID = context.selection.block
                            let currentWidth = try context.engine.block.getWidth(selectedID)
                            try context.engine.block.resizeContentAware([selectedID], width: currentWidth, height: currentWidth)
                        } catch {
                            print("Failed to crop to square: \(error)")
                        }
                    } label: { context in
                        Label("Square", systemImage: "crop")
                    }
                }
            }
            // add save button
            .imgly.dockItems { context in
                Dock.Buttons.imagesLibrary()
                Dock.Buttons.textLibrary()
                Dock.Buttons.stickersLibrary()
                Dock.Button.init(id: .init("SaveButton")) { context in
                    Task {
                        do {
                            showAlert.toggle()
                            alertTitle = "Success"
                            alertMessage = "Great! Your work is saved"
                        } catch {
                            print(error)
                        }
                    }
                } label: { context in
                    Label("Save", systemImage: "externaldrive.badge.plus")
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
    }
}
