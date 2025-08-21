//
//  Superhero.swift
//  FIT3178-W03-Lab
//
//  Created by Jagannath on 15/8/2025.
//

import UIKit

enum Universe: Int {
    case marvel = 0
    case dc = 1
}

class Superhero: NSObject {
    var name: String?
    var abilities: String?
    var universe: Universe?
    
    init(name: String? = nil, abilities: String? = nil, universe: Universe? = nil) {
        self.name = name
        self.abilities = abilities
        self.universe = universe
    }
}
