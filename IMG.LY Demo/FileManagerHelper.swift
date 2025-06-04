//
//  FileManagerHelper.swift
//  IMG.LY Demo
//
//  Created by Amira Soued on 04/06/2025.
//
import SwiftUI

struct FileManagerHelper{
    
    func saveScene(_ string: String, _ sceneFileName: String? = nil) throws {
        let fileName = sceneFileName ?? UUID().uuidString + ".scene"
        let fileURL = getSceneFileURL(fileName)
        if let data = string.data(using: .utf8) {
            try data.write(to: fileURL, options: [.atomicWrite])
            print("Scene saved to: \(fileURL.path)")
            if var savedSceneNames = UserDefaults.standard.array(forKey: "savedSceneNames") as? [String] {
                if !savedSceneNames.contains(fileName) {
                    savedSceneNames.append(fileName)
                }
                UserDefaults.standard.set(savedSceneNames, forKey: "savedSceneNames")
            } else {
                UserDefaults.standard.set([fileName], forKey: "savedSceneNames")
            }
        }
    }
    
    func loadSceneData(_ sceneFileName: String) throws -> String {
        let fileURL = getSceneFileURL(sceneFileName)
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            throw NSError(domain: "FileManagerHelper", code: 404, userInfo: [NSLocalizedDescriptionKey: "Scene file not found."])
        }
        let data = try Data(contentsOf: fileURL)
        print("Scene loaded from: \(fileURL.path)")
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

     func getSceneFileURL(_ sceneFileName: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(sceneFileName)
    }
    
}
