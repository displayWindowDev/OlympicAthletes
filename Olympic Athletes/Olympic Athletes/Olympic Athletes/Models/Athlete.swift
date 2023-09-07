//
//  Athlete.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 21/08/23.
//

import Foundation

internal struct Athlete: Decodable, Equatable, Hashable {
    static func == (lhs: Athlete, rhs: Athlete) -> Bool {
        return lhs.athleteId == rhs.athleteId
    }
    
    internal let athleteId: String?
    internal let name: String?
    internal let surname: String?
    internal let dateOfBirth: String?
    internal let bio: String?
    internal let weight: Int?
    internal let height: Int?
    internal let photoId: Int?
    internal private(set) var imageData: Data?
    internal private(set) var results: [AthleteResut]?
}
