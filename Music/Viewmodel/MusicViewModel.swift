//
//  MusicViewModel.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 18/08/25.
//

import Foundation

//@Observable
class MusicViewModel: ObservableObject {
    typealias ArtistSearch = API.Types.Response.ArtistSearch
    let apiClient = API.Client()
    
    @Published var artists: [API.Types.Response.ArtistSearch.Result]
    
    enum State {
        case loading
        case loaded(ArtistSearch)
        case error(String)
    }
    
    @Published var state: State = .loading
    
    init() {
        artists = []
        state = .loading
    }
    
    @MainActor
    func refresh() async {
        do {
            let artistSearch = try await fetchArtistSearch(query: "justin")
            state = .loaded(artistSearch)
            artists = artistSearch.results
        } catch let error {
            state = .error("\(error)")
        }
    }
    
    @MainActor
    func fetchArtist(query: String) async {
        do {
            let artistSearch = try await fetchArtistSearch(query: query)
            state = .loaded(artistSearch)
            artists = artistSearch.results
        } catch let error {
            state = .error("\(error)")
        }
    }
    
    private func fetchArtistSearch(query: String) async throws -> API.Types.Response.ArtistSearch {
        
        //let body = API.Types.Request.Search(term: query)
        let body = API.Types.Request.Empty()
        
        let artistSearch: API.Types.Response.ArtistSearch = try await apiClient.fetch(
            method: .get,
            body: body,
            endpoint: .search(query: query)
        )
        
        return artistSearch
    }
}
