//
//  EditorView.swift
//  IMG.LY Demo
//
//  Created by Amira Soued on 04/06/2025.
//

import SwiftUI
import IMGLYDesignEditor

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
    }
}
