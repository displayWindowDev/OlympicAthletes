//
//  AthletesRequest.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 21/08/23.
//

import Foundation

/// Returns the full list of athletes
internal struct AthletesRequest: APIRequest {
    typealias Response = [Athlete]
    
    internal var resource: String {
        return "athletes"
    }
}
