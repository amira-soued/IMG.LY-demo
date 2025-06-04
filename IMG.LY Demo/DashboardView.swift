//
//  DashboardView.swift
//  IMG.LY Demo
//
//  Created by Amira Soued on 04/06/2025.
//

import SwiftUI

private let imglyLicenseKey = "ij_CRCIwzhd9DzenrjUUn1YDwbMeAckxvjTDvrRbqHj6gelNUhvTTauAPpM2KQRk"

struct SceneModel: Identifiable {
    let id = UUID()
    let name: String
}

struct DashboardView: View {
    @State private var isNewScenePresented = false
    @State var savedSceneNames = [SceneModel]()
    
    var body: some View {
        NavigationStack{
            VStack{

                if savedSceneNames.isEmpty {
                    noScenesView
                } else {
                    // list of saved created scenes
                   List(savedSceneNames) { scene in
                    NavigationLink(destination: EditorView(item: scene)) {
                        Text(scene.name)
                    }
                   }
                }
                HStack{
                    Spacer()
                    // create new scene
                    Button {
                        isNewScenePresented.toggle()
                    } label: {
                        Text("Create scene")
                            .fontWeight(.bold)
                            .padding()
                            .background(Color("accentColor"))
                            .foregroundStyle(Color.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    Spacer()

                }
            }
            .background(Color("backgroundColor"))
            .navigationDestination(isPresented: $isNewScenePresented) {
                EditorView()
            }
            .onAppear {
                if let savedSceneNames = UserDefaults.standard.array(forKey: "savedSceneNames") as? [String] {
                    self.savedSceneNames = savedSceneNames.map { SceneModel(name: $0) }
                }
            }
        }
    }
    
    var noScenesView: some View {
        VStack{
            Spacer()
            Image(.noData)
                .resizable()
                .scaledToFit()
            Spacer()
        }
    }
}
