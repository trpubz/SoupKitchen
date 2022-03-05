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
    
    init () {
        makeStew()
        print(String(data: jsonData, encoding: .utf8) ?? "brokey-broke whalburg")
    }
    
    mutating func makeStew() {
        let ioHelper: IOModule = IOModule()
        let html = ioHelper.loadHTML()
        print("Successful string load")

        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
            print("Successful doc conversion")
            // gets all asides indside doc
            let aside: Elements = try doc.getElementsByTag("aside")
            print("Successful aside retrieval.")
            // The 1st aside is the Top 300 Table. Inside the aside is header and table.
            let top300Table: Elements = try aside.first()!.select("table")
            print("Successful 1st table retrieval.")
            // There is only 1 tbody so only 1 element; child members are table rows (tr)
            let tRows: Elements = try top300Table.select("tbody > tr")
            // Elements are a collection of children items and casting the object to an array allows iteration
            for row in tRows.array() {
                // player name lives in the 'a' tag
                let player = try row.getElementsByTag("a")
                let strName = try player.text()
                // player id is found in the hyperlink; .slice is a String extension
                let id = try player.attr("href").slice(from: "id/", to: "/")!
                // player team is 4th column/3rd index
                let tm = try row.child(3).text()
                // player position is the 5th column/4th index
                let pos = try row.child(4).text()
                let plyr: Player = Player(id: id,
                                          name: strName,
                                          tm: tm,
                                          pos: pos)
                let encoder = JSONEncoder()
                // setting encoder properties; unsure how .sortedKeys works
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
                let encodedData = try encoder.encode(plyr)
                // logging print
                jsonData.append(encodedData)
                print(String(data: jsonData, encoding: .utf8)!)

            }
        } catch Exception.Error(type: let type,
                                Message: let message) {
            print(type)
            print(message)
        } catch {
            print("ERROR")
        }
        
//        let jsonObj = SwiftJSONFormatter.beautify(jsonString).data(using: .utf8)!
        ioHelper.saveJSON(jsonData: jsonData)
        print("successfully saved data")
    }
}
