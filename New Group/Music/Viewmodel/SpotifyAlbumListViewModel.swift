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
    
    // async publishable data.
    @Published private var albumList: Array<Response.Item> = []
    @Published private var albumImageUrls: Array<URL> = []
    
    init() {
        // set artist id for request
        DataProvider.shared.getArtistsAlbums(id: "6U98XWjrUPnPtPBjEprDmu")
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
    
    // return albumList to view
    func getAlbumList() -> Array<Response.Item> {
        return albumList
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
    
    // return albumImageList to view
    func getAlbumImageUrls() -> Array<URL> {
        return albumImageUrls
    }
}
