//
//  Item.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 13/10/25.
//

import Foundation

extension API.Spotify.Types.Response {
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
}
