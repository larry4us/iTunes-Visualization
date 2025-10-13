//
//  AccessToken.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 13/10/25.
//
import Foundation

extension API.Spotify.Types.Response {
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
}
