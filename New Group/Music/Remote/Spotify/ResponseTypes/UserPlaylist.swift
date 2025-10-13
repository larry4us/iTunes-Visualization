import Foundation

extension API.Spotify.Types.Response {
    
    // MARK: - UserPlaylist
    struct UserPlaylist: Codable {
        let href: String
        let limit: Int
        let offset: Int
        let total: Int
        let playlistObjects: [PlaylistObject]
        
        enum CodingKeys: String, CodingKey {
            case href,limit,offset,total
            case playlistObjects = "items"
        }
    }
    
    // MARK: - Item
    struct PlaylistObject: Codable {
        let collaborative: Bool
        let description: String
        let externalUrls: PlaylistExternalUrls
        let href: String
        let id: String
        let images: [Image]
        let name: String
        let owner: Owner
        let itemPublic: Bool
        let snapshotID: String
        let tracks: Tracks
        let type, uri: String
        
        enum CodingKeys: String, CodingKey {
            case collaborative, description
            case externalUrls = "external_urls"
            case href, id, images, name, owner
            case itemPublic = "public"
            case snapshotID = "snapshot_id"
            case tracks, type, uri
        }
    }
    
    // MARK: - ExternalUrls
    struct PlaylistExternalUrls: Codable {
        let spotify: String
    }
    
    // MARK: - Image
    struct Image: Codable {
        let height: Int?
        let url: String
        let width: Int?
    }
    
    // MARK: - Owner
    struct Owner: Codable {
        let displayName: String
        let externalUrls: PlaylistExternalUrls
        let href: String
        let id, type, uri: String
        
        enum CodingKeys: String, CodingKey {
            case displayName = "display_name"
            case externalUrls = "external_urls"
            case href, id, type, uri
        }
    }
    
    // MARK: - Tracks
    struct Tracks: Codable {
        let href: String
        let total: Int
    }
}
