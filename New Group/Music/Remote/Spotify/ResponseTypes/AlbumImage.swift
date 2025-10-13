//
//  AlbumImage.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 13/10/25.
//
import Foundation

extension API.Spotify.Types.Response {
    struct AlbumImage: Decodable, Hashable {
        let height: Int?
        let url: String?
        let width: Int?
    }
}
