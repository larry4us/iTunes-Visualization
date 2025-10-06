//
//  SpotifyAPI + Client.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 06/10/25.
//

import Foundation
import Combine

extension API.Spotify {
    
    class Client {
        enum ClientError: Error {
            case invalidEncoding(String)
        }
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
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
            urlRequest.httpMethod = HTTPMethods.post.rawValue
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

