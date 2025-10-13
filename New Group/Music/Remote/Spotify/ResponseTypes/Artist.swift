//
//  ArtistAlbums.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 13/10/25.
//

import Foundation

extension API.Spotify.Types.Response {
    struct ArtistAlbums: Decodable, Hashable {
        let items: [Item]?
    }
    
    struct Artist: Decodable, Hashable {
        let name, type: String?
    }
}
