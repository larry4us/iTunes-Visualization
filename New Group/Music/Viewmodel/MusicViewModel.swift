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
    
    @Published var state: State
    
    init() {
        artists = []
        state = .loaded(ArtistSearch(results: [], searchTerm: ""))
    }
    
    @MainActor
    func refresh() async {
        do {
            let artistSearch = try await fetchArtistSearch(query: "")
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
    
    @MainActor
    func fetchArtistWithLimit(query: String, limit: Int) async {
        do {
            let artistSearch = try await fetchArtistSearch(query: query, limit: limit)
            state = .loaded(artistSearch)
            artists = artistSearch.results
        } catch let error {
            state = .error("\(error)")
        }
    }
    
    private func fetchArtistSearch(query: String, limit: Int? = nil) async throws -> API.Types.Response.ArtistSearch {
        
        let body = API.Types.Request.Empty()
        
        var artistSearch: API.Types.Response.ArtistSearch = try await apiClient.fetch(
            method: .get,
            body: body,
            endpoint: .search(query: query),
            limit: limit
        )
        
        artistSearch.searchTerm = query
        
        return artistSearch
    }
}
