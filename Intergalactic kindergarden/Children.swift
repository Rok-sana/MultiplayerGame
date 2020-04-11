//
//  Children.swift
//  Intergalactic kindergarden
//
//  Created by Oksana Bolibok on 01.03.2020.
//  Copyright © 2020 Oksana Bolibok. All rights reserved.
//

import SpriteKit


enum ChildType: Int {
    case type1 = 0, type2, type3, type4, type5
    
    static func random() -> ChildType {
        return ChildType(rawValue: Int(arc4random_uniform(4)) + 1)!
    }
    
    var color: UIColor {
        switch self {
        case .type1:
            return .blue
        case .type2:
            return .orange
        case .type3:
            return .green
        case .type4:
            return .cyan
        case .type5:
            return .red
        }
    }
    
    var emoji : String {
        switch self {
        case .type1:
            return "🧝‍♀️"
        case .type2:
            return "🧜‍♀️"
        case .type3:
            return "🧞‍♂️"
        case .type4:
            return "🧑‍🎤"
        case .type5:
            return "🧚‍♀️"
        }
    }
}

class Child: CustomStringConvertible, Hashable {
    
    func hash(into hasher: inout Hasher) {
        var hasher = Hasher()
        hasher.combine(row * 10 + column)
    }
    
    static func ==(lhs: Child, rhs: Child) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    }
    
    var description: String {
        return "type:\(type) square:(\(column),\(row))"
    }
    
    var imageName: String {
        return "cell"
    }
    
    var column: Int
    var row: Int
    let type: ChildType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, type: ChildType) {
        self.column = column
        self.row = row
        self.type = type
    }
}
