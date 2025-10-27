//
//  AlbumListViewModel.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 06/10/25.
//

import Foundation
import Combine


/// This viewmodel is designed to studies purposes. That's why it uses two approaches for fetching data:
/// Combine and Async/Await.
class SpotifyAlbumListViewModel: ObservableObject {
    
    typealias Response = API.Spotify.Types.Response
    typealias Request = API.Spotify.Types.Request
    
    // Combine Settings
    private var cancellables = Set<AnyCancellable>()
    
    // API client fetching
    private var client = API.Spotify.Client()
    
    // API Settings
    private var donLSpotifyID = "6U98XWjrUPnPtPBjEprDmu"
    
    // Async publishable data.
    @Published var albumList: Array<Response.Item> = []
    @Published var albumImageUrls: Array<URL> = []
    @Published var playlists: Array<API.Spotify.Types.Response.PlaylistObject> = []
    
    init() {
        subscribeToDataProviders()
        
        // set artist id for request
        DataProvider.shared.getArtistAlbums(id: donLSpotifyID)
        DataProvider.shared.getUserPlaylists(userID: "larry4us")
        
    }
    
    func getData() {
        // subscribe
        DataProvider.shared.artistAlbumsSubject
            .sink(receiveValue: { [weak self] items in
                guard let self = self else { return }
                // set data to albumList object
                self.albumList = items
                self.setAlbumImageUrls(with: items)
            }).store(in: &cancellables)
        
    }
    
    private func limitImagesURLCount(to count: Int) -> [URL] {
        playlists.flatMap { playlist in
            playlist.images
                .prefix(count)
                .compactMap { URL(string: $0.url) }
        }
    }
    
    private func subscribeToDataProviders() {
        // Albums
        DataProvider.shared.artistAlbumsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                guard let self = self else { return }
                self.albumList = items
                self.setAlbumImageUrls(with: items)
            }
            .store(in: &cancellables)
        
        // Playlists
        DataProvider.shared.userPlaylistSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] playlists in
                guard let self = self else { return }
                //print("🎵 Received playlists:", playlists.map(\.name))
                self.playlists = playlists
            }
            .store(in: &cancellables)
    }
    
    // some collection type transactions
    private func setAlbumImageUrls(with albums: [Response.Item]) {
        for album in albums {
            if let firstImageUrl = album.images?.first?.url,
               let imageUrl = URL(string: firstImageUrl) {
                albumImageUrls.append(imageUrl)
            }
        }
    }
    
    //MARK: Abordagem mais moderna de manipulação da playlist
    
    func createNewPlaylist(named name: String) async -> API.Spotify.Types.Response.PlaylistResponse? {
        
        let body = Request.CreatePlaylist(
            name: "Playlist mais cool do mundo",
            description: "Fumaça pro ar",
            publicPlaylist: false
        )
        
        do {
            let response: API.Spotify.Types.Response.PlaylistResponse = try await client.post(
                to: .createPlaylist(
                    userID: "larry4us"
                ),
                body: body
            )
            return response
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
