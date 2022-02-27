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
        let path = "/Users/tpubz/Documents/_code/SoupKitchen/SoupKitchen/Resources/h2hArticle.html"
        let url = URL(fileURLWithPath: path)

        do {
            let html: String = try String(contentsOf: url, encoding: .utf8)
            print("Successful string conversion")
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
            print("Successful doc conversion")
            // gets all asides indside doc
            let aside: Elements = try doc.getElementsByTag("aside")
            print("Successful aside retrieval.")
            // The 1st aside is the Top 300 Table. Inside the aside is header and table.
            let top300Table: Elements = try aside.first()!.select("table")
            print("Successful 1st table retrieval.")
            let tbody: Elements = try top300Table.select("tbody")
            
        } catch Exception.Error(type: let type, Message: let message) {
            print(type)
            print(message)
        } catch {
            print("ERROR")
        }
    }
}
