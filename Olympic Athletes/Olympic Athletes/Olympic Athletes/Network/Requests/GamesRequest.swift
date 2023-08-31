//
//  GamesRequest.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 22/08/23.
//

import Foundation

/// Returns the full list of games
internal struct GamesRequest: APIRequest {
    typealias Response = [Game]
    
    internal var resource: String {
        return "games"
    }
}
