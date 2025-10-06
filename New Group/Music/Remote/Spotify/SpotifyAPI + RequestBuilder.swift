//
//  SpotifyAPI + RequestBuilder.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 06/10/25.
//
import Foundation

extension API.Spotify {
    
    struct RequestBuilder {
        static let baseURL = "https://accounts.spotify.com"
        static let encodedAuthKey = "ENCODED_AUTH_KEY_WITH_BASE64"
        
        static func makeRequest(for endpoint: Types.Endpoint,
                                method: Types.Method,
                                body: [String: Any]? = nil) -> URLRequest {
            var request = URLRequest(url: endpoint.url)
            request.httpMethod = method.rawValue.uppercased()
            
            // 🔹 Headers padrão
            request.setValue("Basic \(encodedAuthKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            // 🔹 Body padrão (se existir)
            if let body = body {
                var bodyString = body.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
                bodyString.append("&grant_type=client_credentials")
                request.httpBody = bodyString.data(using: .utf8)
            }
            
            return request
        }
    }
}
