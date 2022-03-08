//
//  Kitchen.swift
//  SoupKitchen
//
//  Created by Taylor Pubins on 2/26/22.
//

import Foundation
import SwiftSoup
import SwiftJSONFormatter
import SwiftyJSON

struct SoupStew {
    var jsonData: Data = Data()
    var players: [Player] = []
    
    init () {
        makeStew()
        print(String(data: jsonData, encoding: .utf8) ?? "brokey-broke whalburg")
    }
    
    mutating func makeStew() {
        let ioHelper: IOModule = IOModule()
        let html = ioHelper.loadHTML()
//        print("Successful string load")

        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
            // gets all asides indside doc
            let asides: Elements = try doc.getElementsByTag("aside")
            // The 1st aside is the Top 300 Table.  We want everything but Top 300.
            // There is only 1 tbody so only 1 element; child members are table rows (tr)
            for posTable in asides.array() {
                // first table is Top300; don't need
                if posTable == asides.first() {
                    continue
                }
                
                // determins table attributes for proper column indicies
                var colTm: Int = 0
                var colOtherPos: Int = 0
                for column in try posTable.select("th").array() {
                    switch try column.text() {
                    case "Team": colTm = try column.elementSiblingIndex()
                    case "Other Elig. Pos.": colOtherPos = try column.elementSiblingIndex()
                    default: continue
                    }
                }
                
                // determines which table the loop is currently in
                let playerPostion: String = determinePositionTable(posTable: posTable) ?? "No Position"
                
                let tRows: Elements = try posTable.select("tbody > tr")
                for row in tRows.array() {
                    // player name lives in the 'a' tag
                    let player = try row.getElementsByTag("a")
                    // player id is found in the hyperlink; .slice is a String extension
                    let id = try player.attr("href").slice(from: "id/", to: "/")!
                    // if the player already exists in the players array then continue onto the next row
                    if players.contains(where: {$0.id == id}) { continue }
                    let strName = try player.text()
                    let tm = try row.child(colTm).text()
                    // other positions columns is either "" or not
                    var otherPositions: String = try row.child(colOtherPos).text()
                    if otherPositions != "" {
                        // this tactic add a '/' to the front of the string
                        otherPositions = "/\(otherPositions)"
                    }
                    let plyr: Player = Player(id: id,
                                              name: strName,
                                              tm: tm,
                                              pos: playerPostion + otherPositions)
                    players.append(plyr)
//                    print(plyr)
                }
            }
        } catch Exception.Error(type: let type,
                                Message: let message) {
            print(type)
            print(message)
        } catch { print("ERROR") }
        
        let encoder = JSONEncoder()
        // setting encoder properties; unsure how .sortedKeys works
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        do {
            let encodedData = try encoder.encode(players)
            jsonData.append(encodedData)
//            print(String(data: jsonData, encoding: .utf8)!)
        } catch { print("Encoder Error") }
        
        ioHelper.saveJSON(jsonData: jsonData)
        print("successfully saved data")
    }
}

extension SoupStew {
    func determinePositionTable(posTable: Element) -> String? {
        do {
            let posGroup: String = try posTable.select("h2").text()
            if posGroup.contains("Catchers") {
                return "C"
            } else if posGroup.contains("First Basemen") {
                return "1B"
            } else if posGroup.contains("Second Basemen") {
                return "2B"
            } else if posGroup.contains("Third Basemen") {
                return "3B"
            } else if posGroup.contains("Shortstops") {
                return "SS"
            } else if posGroup.contains("Outfielders") {
                return "OF"
            } else if posGroup.contains("Starting Pitchers") {
                return "SP"
            } else if posGroup.contains("Relief Pitchers") {
                return "RP"
            } else if posGroup.contains("Designated Hitters") {
                return "DH"
            } else { return "Couldn't Find Position Match" }
        } catch {
            print("Position Table Determination Error")
        }
        return nil
    }
}
