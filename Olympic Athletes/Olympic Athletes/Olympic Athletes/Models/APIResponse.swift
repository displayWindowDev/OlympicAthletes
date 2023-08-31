//
//  APIResponse.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 22/08/23.
//

import Foundation

/// Top level response for every request to the API
/// Everything in the API seems to be optional, so we cannot rely on having values here
public struct APIResponse<Response: Decodable>: Decodable {
    /// Whether it was ok or not
    public let status: String?
    /// Message that usually gives more information about some error
    public let message: String?
    /// Requested data
    public let data: DataContainer<Response>?
}

/// All successful responses return this, and contains all
/// the metainformation about the returned chunk.
public struct DataContainer<Results: Decodable>: Decodable {
    public let offset: Int
    public let limit: Int
    public let total: Int
    public let count: Int
    public let results: Results
}
