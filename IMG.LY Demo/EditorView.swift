//
//  EditorView.swift
//  IMG.LY Demo
//
//  Created by Amira Soued on 04/06/2025.
//

import SwiftUI
import IMGLYEngine
import IMGLYCore
import IMGLYDesignEditor

struct EditorView : View {
    
    @State var item: SceneModel?
    var engineSettings = EngineSettings(license: "ij_CRCIwzhd9DzenrjUUn1YDwbMeAckxvjTDvrRbqHj6gelNUhvTTauAPpM2KQRk")
    
    let fileManagerHelper = FileManagerHelper()
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {

        DesignEditor(engineSettings)
            // load saved scenes or default empty scene
            .imgly.onCreate { engine in
                if let item {
                    try await OnCreate.loadScene(from: DesignEditor.defaultScene)(engine)
                    await loadInitialScene(engine: engine, sceneName: item.name)
                } else {
                    try await OnCreate.loadScene(from: DesignEditor.defaultScene)(engine)
                }
            }
            // export scene as image
            .imgly.onExport { engine, eventHandler in
                try await OnExport.default(mimeType: .png)(engine, eventHandler)
            }
            // add save button
            .imgly.dockItems { context in
                Dock.Buttons.imagesLibrary()
                Dock.Buttons.textLibrary()
                Dock.Buttons.stickersLibrary()
                Dock.Button.init(id: .init("SaveButton")) { context in
                    Task {
                        do {
                            let scene = context.engine.scene
                            let sceneString = try await scene.saveToString()
                            if let item {
                                try fileManagerHelper.saveScene(sceneString, item.name)
                            } else {
                                let itemName = UUID().uuidString
                                self.item = .init(name: itemName)
                                try fileManagerHelper.saveScene(sceneString, itemName)
                            }
                        } catch {
                            print(error)
                        }
                    }
                } label: { context in
                    Label("Save", systemImage: "externaldrive.badge.plus")
                }
            }
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // Function to load the initial scene (either saved or default)
    private func loadInitialScene(engine: Engine, sceneName: String) async {
        do {
            print("Attempting to load saved scene on startup...")
            let sceneString = try FileManagerHelper().loadSceneData(sceneName)
            if !sceneString.isEmpty {
                try await engine.scene.load(from: sceneString) // Load from String
            } else {
                // Throw an error if conversion from Data to String fails
                throw NSError(domain: "ContentView", code: 1003, userInfo: [NSLocalizedDescriptionKey: "Failed to decode scene data from file."])
            }
        } catch let error as NSError where error.domain == "FileManagerHelper" && error.code == 404 {
            print("No saved scene file found. Creating a default scene.")
            try? await OnCreate.loadScene(from: DesignEditor.defaultScene)(engine)
        }
        catch {
            print("Could not load saved scene: \(error.localizedDescription). Creating a default scene.")
            try? await OnCreate.loadScene(from: DesignEditor.defaultScene)(engine)
        }
    }
    
    // Helper to present alerts
    private func presentAlert(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.showAlert = true
    }
}
