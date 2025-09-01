//
//  ContentView.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 11/08/25.
//

import SwiftUI

struct ContentView: View {
    
    typealias artistSearch = API.Types.Response.ArtistSearch
    let columns = Array(repeating: GridItem(.flexible(minimum: 50)), count: 2)
    @StateObject var vm: MusicViewModel
    @State var searchText = ""
    @State var numberOfResults = 6
    
    var body: some View {
        SearchBarView(text: $searchText, numberOfResults: $numberOfResults, onSearch: {
            Task { await vm.fetchArtistWithLimit(query: searchText, limit: numberOfResults) }
        })
        Text("\(vm.artists.count)")
        ScrollView(.vertical) {
            LazyVGrid(columns: columns) {
                contentView
                    .onAppear {
                        Task {await vm.refresh()}
                    }
                    .containerRelativeFrame(.vertical, count: 2, spacing: 16)
                
            }
            .scrollTargetLayout()
        }
        .contentMargins(16, for: .scrollContent)
        .scrollTargetBehavior(.paging)
    }
    
    @ViewBuilder
    var contentView: some View {
        switch vm.state {
        case .error(let error):
            Text("houve um erro: \(error)")
        case .loaded:
            ForEach(vm.artists){ artist in
                artistCard(artist: artist)
            }
        case .loading:
            ProgressView()
        }
    }
    
    
    func artistCard(artist: artistSearch.Result) -> some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: artist.artworkUrl100)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text(artist.artistName)
                    .font(.headline)
                Text(artist.kind.capitalized)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .frame(width: 150, height: 200)
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        
    }
}

#Preview {
    ContentView(vm: .init())
}
