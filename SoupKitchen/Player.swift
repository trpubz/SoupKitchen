//
//  Player.swift
//  SoupKitchen
//
//  Created by Taylor Pubins on 3/2/22.
//

import Foundation

struct Player: Codable {
    let id: String
    let name: String
    let firstName: String
    let lastName: String
    var suffix: String? = nil
    let tm: String
    let pos: String
    
    init(id: String, name: String, tm: String, pos: String) {
        self.id = id
        self.name = name
        self.tm = tm
        self.pos = pos
        let compsName = name.components(separatedBy: " ")
        self.firstName = compsName[0]
        self.lastName = compsName[1]
        if compsName.endIndex > 2 {
            self.suffix = compsName[2]
        }
    }
}
