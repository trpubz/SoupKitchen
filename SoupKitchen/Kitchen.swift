//
//  Kitchen.swift
//  SoupKitchen
//
//  Created by Taylor Pubins on 2/26/22.
//

import Foundation
import SwiftSoup
import SwiftJSONFormatter

struct SoupStew {
    var jsonString: String = ""
    
    init () {
        makeStew()
        print(SwiftJSONFormatter.beautify(jsonString))
    }
    
    mutating func makeStew() {
        let file = URL(fileURLWithPath: "/Users/Shared/h2hArticle.html")

        do {
            let html: String = try String(contentsOf: file, encoding: .utf8)
            print("Successful string conversion")
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
            for row in tRows.array() {
                let player = try row.getElementsByTag("a")
                let strName = try player.text()
                let id = try player.attr("href").slice(from: "id/", to: "/")!
                let tm = try row.child(3).text()
                let pos = try row.child(4).text()
                let plyr: Player = Player(id: id,
                                          name: strName,
                                          tm: tm,
                                          pos: pos)
                let encodedData = try JSONEncoder().encode(plyr)
                jsonString.append(contentsOf: String(data: encodedData,
                                                     encoding: .utf8)!)
            }
        } catch Exception.Error(type: let type,
                                Message: let message) {
            print(type)
            print(message)
        } catch {
            print("ERROR")
        }
    }
}
