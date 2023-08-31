//
//  AthleteResultsRequest.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 22/08/23.
//

import Foundation

/// Returns all results for an athlete
internal struct AthleteResultsRequest: APIRequest {
    typealias Response = [AthleteResut]
    
    internal let athleteId: String
    internal var resource: String {
        return "athletes/\(athleteId)/results"
    }
}
