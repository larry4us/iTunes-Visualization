//
//  APIClient.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 11/08/25.
//

import Foundation

extension API {
    
    class Client {
        
        enum ClientError: Error {
            case invalidEncoding(String)
        }
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        func fetch<Request:Encodable, Response: Decodable> (
            method: Types.method,
            body: Request? = nil,
            endpoint: Types.Endpoint,
            limit: Int? = nil
        ) async throws -> Response {
            
            // creating the URL request
            var url = endpoint.url
            if let limit {
                url = url.appending(queryItems: [URLQueryItem(name: "limit", value: "\(limit)")])
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue.uppercased()
            
            // if not a get method, try to fill in the body
            if method != .get {
                if let body {
                    do {
                        urlRequest.httpBody = try encoder.encode(body)
                    } catch let error {
                        throw ClientError.invalidEncoding(error.localizedDescription)
                    }
                }
            }
            
            // fetching
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            // checking response
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw API.Types.Error.generic(reason: "A requisição falhou com o status: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
            }
            
            // decoding the data
            do {
                print("Received data: \(String(data: data, encoding: .utf8) ?? "Unable to decode data")")
                // try decoder.decode(Response.self, from: data, configuration: .decodingConfiguration)
                let decodedData = try decoder.decode(Response.self, from: data)
                return decodedData
                
            } catch let error {
                throw API.Types.Error.generic(reason: "\(error)")
            }
        }
        
        
    }
}


