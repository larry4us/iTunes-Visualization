//
//  SpotifyAPI + DataProvider.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 06/10/25.
//

import Foundation
import Combine

class DataProvider {
    
    static let shared = DataProvider()
    
    private var cancellables = Set<AnyCancellable>()
    
    // Subscribers
    var artistAlbumsSubject = PassthroughSubject<[API.Spotify.Types.Response.Item], Never>()
    var userPlaylistSubject = PassthroughSubject<[API.Spotify.Types.Response.PlaylistObject], Never>()
    
    private init() {}
}

extension DataProvider {
    
    typealias Response = API.Spotify.Types.Response
    
    func getArtistAlbums(id: String) {
        // request url
        let url = URL(string: "https://api.spotify.com/v1/artists/\(id)/albums")
        // request model with decodable ArtistAlbums model and http method
        let model = APIManager<Response.ArtistAlbums>.RequestModel(url: url, method: .get)
        // init request
        APIManager.shared.request(with: model)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error)
            }
        }, receiveValue: { albums in
            // successful request
            guard let items = albums.items else { return }
            // publish the data
            self.artistAlbumsSubject.send(items)
        }).store(in: &self.cancellables)
    }
    
    func getUserPlaylists(userID: String) {
        // request url
        let url = URL(string: "https://api.spotify.com/v1/users/\(userID)/playlists")
        // request model with decodable ArtistAlbums model and http method
        let model = APIManager<Response.UserPlaylist>.RequestModel(url: url, method: .get)
        // init request
        APIManager.shared.request(with: model)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error)
            }
        }, receiveValue: { response in
            // publish the data
            self.userPlaylistSubject.send(response.playlistObjects)
            
        }).store(in: &self.cancellables)
        
    }
    
    func makeNewPlaylist(userID: String, name: String) {
        let url = URL(string: "https://api.spotify.com/v1/users/\(userID)/playlists")
        let model = APIManager<Response.UserPlaylist>.RequestModel(url: url, method: .post)
    }
}
