//
//  Game.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 21/08/23.
//

import Foundation

internal struct Game: Hashable, Decodable {
    internal var game_id: Int?
    internal var city: String?
    internal var year: Int?
}
