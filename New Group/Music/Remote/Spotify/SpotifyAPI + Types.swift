//
//  SpotifyAPI + dataModel.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 06/10/25.
//

import Foundation

extension API.Spotify {
    
    enum Types {
        
        enum Response {

        }
        
        enum Request {
            struct Empty: Encodable {}
            
            struct Search: Encodable {
                var term: String
            }
        }
        
        enum Error: LocalizedError {
            case generic(reason: String)
            case `internal`(reason: String)
            
            var errorDescription: String? {
                switch self {
                case .generic(let reason):
                    return reason
                case .internal(reason: let reason):
                    return "Internal error: \(reason)"
                }
            }
        }
        
        enum Endpoint {
            case search(query: String)
            case lookup(id: Int)
            
            var url: URL {
                var components = URLComponents()
                components.scheme = "https"
                components.host = "accounts.spotify.com"
                components.path = "/api/token"
                return components.url!
            }
        }
        
        enum Method: String {
            case get
            case post
        }
    }
}
