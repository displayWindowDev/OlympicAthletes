//
//  NetworkError.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 24/08/23.
//

import Foundation

public enum NetworkError: Error, LocalizedError {
    
    /// 400
    case badRequest
    /// 401
    case unauthorized
    /// 402
    case paymentRequired
    /// 403
    case forbidden
    /// 404
    case notFound
    /// 413
    case requestEntityTooLarge
    /// 422
    case unprocessableEntity

    case http(httpResponse: HTTPURLResponse, data: Data)
    case missingRequiredFields(String)
    case invalidParameters(operation: String, parameters: [Any])
    case invalidResponse(Data)
    case deleteOperationFailed(String)
    case network(URLError)
    case unknown(Error?)
}
