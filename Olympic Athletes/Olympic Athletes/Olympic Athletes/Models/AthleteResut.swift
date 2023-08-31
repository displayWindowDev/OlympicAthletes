//
//  AthleteResut.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 22/08/23.
//

import Foundation

internal struct AthleteResut: Decodable, Hashable {
    internal var city: String?
    internal var year: Int?
    internal var gold: Int?
    internal var silver: Int?
    internal var bronze: Int?
}
