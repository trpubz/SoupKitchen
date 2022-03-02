//
//  Kitchen.swift
//  SoupKitchen
//
//  Created by Taylor Pubins on 2/26/22.
//

import Foundation
import SwiftSoup

struct SoupStew {
    init () {
        makeStew()
    }
    
    func makeStew() {
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
            print(tRows.count)
        } catch Exception.Error(type: let type, Message: let message) {
            print(type)
            print(message)
        } catch {
            print("ERROR")
        }
    }
}
