//
//  SpotifyAPI.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 06/10/25.
//

//
//  API + AuthManager.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 06/10/25.
//

import Foundation
import Combine

extension API.Spotify {
    
    class AuthManager {
        
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
        
    }
}

