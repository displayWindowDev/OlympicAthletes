//
//  AthleteRequest.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 22/08/23.
//

import Foundation

/// Returns information about an athlete given its id
internal struct AthleteRequest: APIRequest {
    typealias Response = Athlete
    
    internal let athleteId: String
    internal var resource: String {
        return "athletes/\(athleteId)"
    }
}
