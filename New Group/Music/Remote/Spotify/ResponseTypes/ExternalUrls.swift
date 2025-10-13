//
//  ExternalUrls.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 13/10/25.
//

import Foundation

extension API.Spotify.Types.Response {
    struct ExternalUrls: Decodable, Hashable {
        let spotify: String?
    }
}
