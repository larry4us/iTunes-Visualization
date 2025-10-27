//
//  SpotifyAPI + AuthManager.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 06/10/25.
//

import Foundation
import Combine

extension API.Spotify {
    class AuthManager {
        
        enum ClientError: Error {
            case invalidEncoding(String)
        }
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        static let shared = AuthManager()
        
        static internal let authKey: String = {
            let clientID = "ac179c87d2b9497198ec2b2cf657491c"
            let clientSecret = "537c58d65efa4c2c92625ca6dcd11694"
            let rawKey = "\(clientID):\(clientSecret)"
            let encodedKey = rawKey.data(using: .utf8)?.base64EncodedString() ?? ""
            return "Basic \(encodedKey)"
        }()
        
        // Authentication URL
        static internal let tokenURL: URL? = {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "accounts.spotify.com"
            components.path = "/api/token"
            return components.url
        }()
        
        func getAccessToken() async throws -> String {
            guard let url = Self.tokenURL else {
                throw URLError(.badURL)
            }
            var req = URLRequest(url: url)
            req.httpMethod = "POST"
            req.setValue(Self.authKey, forHTTPHeaderField: "Authorization")
            req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            req.httpBody = "grant_type=client_credentials".data(using: .utf8)
            
            let (data, response) = try await URLSession.shared.data(for: req)
            guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
                throw URLError(.badServerResponse)
            }
            let decoded = try JSONDecoder().decode(API.Spotify.Types.Response.AccessToken.self, from: data)
            return decoded.token ?? ""
        }
        
        /// Request method for access token.
        func getAccessToken() -> AnyPublisher<String, Error> {
            // strong token url
            guard let url = AuthManager.tokenURL else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }
            // url request setups
            var urlRequest = URLRequest(url: url)
            // add authKey to "Authorization" for request headers
            urlRequest.allHTTPHeaderFields = ["Authorization": AuthManager.authKey,
                                              "Content-Type": "application/x-www-form-urlencoded"]
            // add query items for request body
            var requestBody = URLComponents()
            
            requestBody.queryItems = [URLQueryItem(name: "grant_type", value: "client_credentials")]
            urlRequest.httpBody = requestBody.query?.data(using: .utf8)
            urlRequest.httpMethod = Types.Method.post.rawValue
            
            // return dataTaskPublisher for request
            return URLSession.shared
                .dataTaskPublisher(for: urlRequest)
                .tryMap { data, response in
                    // throw error when bad server response is received
                    guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
            // decode the data with AccessToken decodable model
                .decode(type: Types.Response.AccessToken.self, decoder: decoder)
            // reinforce for decoded data
                .map { accessToken -> String in
                    guard let token = accessToken.token else {
                        print("The access token is not fetched.")
                        return ""
                    }
                    return token
                }
            // main thread transactions
                .receive(on: RunLoop.main)
            // publisher spiral for AnyPublisher<String, Error>
                .eraseToAnyPublisher()
        }
        
    }
    
}
