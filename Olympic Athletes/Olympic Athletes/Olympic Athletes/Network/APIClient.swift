//
//  APIClient.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 21/08/23.
//

import Foundation

public typealias ResultCallback<Value> = (Result<Value, Error>) -> Void

/// Implementation of a generic-based API client
public class APIClient {
    private let baseEndpointUrl = URL(string: "https://ocs-test-backend.onrender.com/")!
    
    private let session = URLSession(configuration: .default)

    /// Encodes a URL based on the given request
    /// - Parameter request: API Request with generic type T
    /// - Returns: Request endpoint
    public func endpoint<T: APIRequest>(for request: T) -> URL {
        guard let baseUrl = URL(string: request.resource, relativeTo: baseEndpointUrl),
              let components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true),
              let endpoint = components.url else {
            fatalError("Bad resource path: \(request.resource)")
        }

        return endpoint
    }
    
    /// Sends a request to servers, calling the completion method when finished
    /// - Parameters:
    ///   - request: API Request with generic type T
    ///   - completion: Request sending completion handler
    public func send<T: APIRequest>(_ request: T, completion: @escaping ResultCallback<T.Response>) {
        let endpoint = self.endpoint(for: request)
        
        self.session.dataTask(with: URLRequest(url: endpoint)) { data, response, error in
            
            if let data {
                do {
                    let decodedData = try self.parseResponse(request, data: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(decodedData))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }.resume()
        
    }

    /// Sends a request to servers specifically for image data, calling the completion method when finished
    /// - Parameters:
    ///   - request: API Request with generic type T
    ///   - completion: Image fetching completion handler
    public func fetchImage<T: APIRequest>(_ request: T, completion: @escaping ResultCallback<Data>) {
        let endpoint = self.endpoint(for: request)

        self.session.dataTask(with: URLRequest(url: endpoint)) { data, response, error in
            if let data {
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
    
    /// Parses a response from server
    /// - Parameters:
    ///   - request: API Request with generic type T
    ///   - data: Data to be parsed
    /// - Returns: Parsed response with generic type T
    public func parseResponse<T: APIRequest>(_ request: T, data: Data) throws -> T.Response {
        return try JSONDecoder().decode(T.Response.self, from: data)
    }
    
}
