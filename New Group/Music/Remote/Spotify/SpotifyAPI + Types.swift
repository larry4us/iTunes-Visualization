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
            struct PlaylistResponse: Decodable {
                let id: String
                let name: String
            }
        }
        
        enum Request {
            struct Empty: Encodable {}
            
            struct Search: Encodable {
                var term: String
            }
            
            struct CreatePlaylist: Encodable {
                var name: String
                let description: String?
                let publicPlaylist: Bool
                
                
                enum CodingKeys: String, CodingKey {
                    case name
                    case description
                    case publicPlaylist = "public"
                }
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
            case createPlaylist(userID: String)
            
            var url: URL {
                var components = URLComponents()
                components.scheme = "https"
                components.host = "api.spotify.com"
                
                switch self {
                case .search(let query):
                    components.path = "/search"
                    components.queryItems = [
                        URLQueryItem(name: "term", value: query),
                        URLQueryItem(name: "media", value: "music"),
                        URLQueryItem(name: "attribute", value: "artistTerm")
                    ]
                case .lookup(let id):
                    components.path = "/lookup"
                    components.queryItems = [
                        URLQueryItem(name: "id", value: "\(id)")
                    ]
                case .createPlaylist(let userID):
                    components.path = "/v1/users/\(userID)/playlists"
                }
                
                return components.url!
            }
        }
        
        enum Method: String {
            case get
            case post
        }
    }
}
