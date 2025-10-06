//
//  APITypes.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 11/08/25.
//

import Foundation

extension API {
    
    enum Types {
        
        enum Response {
            struct SongSearch: Decodable {
                var resultCount: Int
                var results: [Result]
                var searchTerm: String = ""
                
                struct Result: Decodable, CustomStringConvertible, Identifiable {
                    var id = UUID()
                    var kind: String
                    var artistName: String
                    var artworkUrl100: String
                    var previewUrl: String
                    var trackName: String
                    
                    var description: String {
                        "tipo: \(kind), artista: \(artistName)"
                    }
                    
                    private enum CodingKeys: String, CodingKey {
                        case kind
                        case artistName
                        case artworkUrl100
                        case previewUrl
                        case trackName
                    }
                }
                
                private enum CodingKeys: String, CodingKey {
                    case resultCount
                    case results
                }

            }
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
                components.host = "itunes.apple.com"
                
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
                }
                
                return components.url!
            }
        }
        
        enum method: String {
            case get
            case post
        }
    }
}
