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
        let url = URL(fileURLWithPath: "/Users/trpubz/Documents/_code/SoupKitchen/SoupKitchen/Resources/h2hArticle.html")
        print(url)
//        guard let url = (forResource: "h2hArticle", withExtension: ".html") else {
//            fatalError("Cannot locate file")
//        }

        do {
            let html: String = try String(contentsOf: url, encoding: .utf8)
            print("Successful string conversion")
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
            print("Successful doc conversion")
            let article: Elements = try doc.getElementsByTag("article")
            print("Successful article retrival.")
            print(try article.text())
        } catch Exception.Error(type: let type, Message: let message) {
            print(type)
            print(message)
        } catch {
            print("ERROR")
        }
    }
}
