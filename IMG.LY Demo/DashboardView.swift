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
            ZStack{
                VStack{
                    // list of saved created scenes
                    List(savedSceneNames) { scene in
                        
                    }
                    HStack{
                        Spacer()
                        // create new scene
                        Button {
                            isNewScenePresented.toggle()
                        } label: {
                            Text("New scene")
                                .fontWeight(.bold)
                                .padding()
                                .background(Color("PrimaryButtonColor"))
                                .foregroundStyle(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                            
                        }
                        .padding()
                        
                        Spacer()
                    }
                    Spacer()
                    
                }
            }
            .navigationDestination(isPresented: $isNewScenePresented) {
                EditorView()
            }
        }
        
    }
}
