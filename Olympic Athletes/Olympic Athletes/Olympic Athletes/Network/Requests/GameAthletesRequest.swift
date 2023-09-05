//
//  GameAthletesRequest.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 22/08/23.
//

import Foundation

/// Returns all athletes that have competed in a game, given its id
internal struct GameAthletesRequest: APIRequest {
    typealias Response = [Athlete]
    
    internal let gameId: Int
    internal var resource: String {
        return "games/\(gameId)/athletes"
    }
}
