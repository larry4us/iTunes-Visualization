//
//  MusicViewModel.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 18/08/25.
//

import Foundation

//@Observable
class MusicViewModel: ObservableObject {
    typealias SongSearch = API.Types.Response.SongSearch
    let apiClient = API.Client()
    
    @Published var songs: [SongSearch.Result]
    @Published var numberOfResults: Int = 1
    
    var lastSearchedTerm = ""
    
    enum State {
        case loading
        case loaded(SongSearch)
        case error(String)
    }
    
    @Published var state: State
    
    init() {
        songs = []
        state = .loaded(SongSearch(resultCount: 0, results: [], searchTerm: ""))
    }
    
    @MainActor
    func refresh() async {
        do {
            // se houver músicas pesquisadas, pega o termo de busca e renova
            switch state {
            case .loaded(let songSearch):
                let songSearch = try await fetchSongSearch(query: songSearch.searchTerm, limit: numberOfResults)
                state = .loaded(songSearch)
                songs = songSearch.results
            default:
                break
            }
        } catch let error {
            state = .error("\(error)")
        }
    }
    
    @MainActor
    func fetchSongsWithLimit(query: String, limit: Int) async {
        do {
            let songSearch = try await fetchSongSearch(query: query, limit: numberOfResults)
            state = .loaded(songSearch)
            songs = songSearch.results
        } catch let error {
            state = .error("\(error)")
        }
    }
    
    private func fetchSongSearch(query: String, limit: Int? = nil) async throws -> SongSearch {
        
        let body = API.Types.Request.Empty()
        
        var songSearch: SongSearch = try await apiClient.fetch(
            method: .get,
            body: body,
            endpoint: .search(query: query),
            limit: limit
        )
        
        songSearch.searchTerm = query
        
        return songSearch
    }
}
