//
//  AthletePhotoRequest.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 22/08/23.
//

import Foundation

/// Returns the athlete photo given its id
internal struct AthletePhotoRequest: APIRequest {
    typealias Response = Data
    
    internal let athleteId: String
    internal var resource: String {
        return "athletes/\(athleteId)/photo"
    }
}
