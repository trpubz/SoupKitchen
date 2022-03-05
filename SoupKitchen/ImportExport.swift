//
//  ImportExport.swift
//  SoupKitchen
//
//  Created by Taylor Pubins on 3/3/22.
//

import Foundation

struct IOModule {
    let sharedLocation: URL = URL(fileURLWithPath: "/Users/Shared/")
}

extension IOModule {
    func loadHTML(fileName: String = "h2hArticle.html") -> String {
        let filePath: URL = sharedLocation.appendingPathComponent(fileName, isDirectory: false)
        do {
            return try String(contentsOf: filePath, encoding: .utf8)
        } catch {
            print("return error")
            return "numnutz"
        }
    }
    
    func saveJSON(jsonData: Data, fileName: String = "espnTop300Players.json") {
        let pathWithFileName = sharedLocation.appendingPathComponent(fileName)
           do {
               try jsonData.write(to: pathWithFileName)
           } catch {
               print("Error saving file")
           }
    }
}
