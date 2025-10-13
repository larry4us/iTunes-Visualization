//
//  AlbumListViewModel.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 06/10/25.
//


import Foundation
import Combine

class SpotifyAlbumListViewModel: ObservableObject {
    typealias Response = API.Spotify.Types.Response
    private var cancellables = Set<AnyCancellable>()
    private var donLSpotifyID = "6U98XWjrUPnPtPBjEprDmu"
    
    // async publishable data.
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
                print("🎵 Received playlists:", playlists.map(\.name))
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
}
