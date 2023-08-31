//
//  APIRequest.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 21/08/23.
//

import Foundation

public protocol APIRequest: Encodable {
    associatedtype Response: Decodable
    
    /// API endpoint (es. /athletes; /games; etc...)
    var resource: String { get }
}
