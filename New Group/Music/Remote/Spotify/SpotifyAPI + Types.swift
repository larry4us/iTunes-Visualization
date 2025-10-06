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
            struct AccessToken: Decodable {
                let token: String?
                let type: String?
                let expire: Int?
                
                enum CodingKeys: String, CodingKey {
                    case token = "access_token"
                    case type = "token_type"
                    case expire = "expires_in"
                }
            }

            struct ArtistAlbums: Decodable, Hashable {
                let items: [Item]?
            }

            struct Item: Decodable, Identifiable, Hashable {
                let id = UUID()
                let albumType: String?
                let name: String?
                let releaseDate: String?
                let artists: [Artist]?
                let images: [AlbumImage]?
                let externalUrls: ExternalUrls?
                let totalTracks: Int?

                enum CodingKeys: String, CodingKey {
                    case artists, images, name
                    case albumType = "album_type"
                    case releaseDate = "release_date"
                    case externalUrls = "external_urls"
                    case totalTracks = "total_tracks"
                }
            }

            struct ExternalUrls: Decodable, Hashable {
                let spotify: String?
            }

            struct Artist: Decodable, Hashable {
                let name, type: String?
            }

            struct AlbumImage: Decodable, Hashable {
                let height: Int?
                let url: String?
                let width: Int?
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
