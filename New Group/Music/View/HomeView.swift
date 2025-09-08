//
//  ContentView.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 11/08/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    
    typealias artistSearch = API.Types.Response.ArtistSearch
    
    let columns = Array(repeating: GridItem(.flexible(minimum: 50)), count: 2)
    
    @StateObject var vm: MusicViewModel
    @State var searchText = ""
    @State var numberOfResults = 10
    
    var body: some View {
        SearchBarView(text: $searchText, numberOfResults: $numberOfResults, onSearch: {
            Task { await vm.fetchArtistWithLimit(query: searchText, limit: numberOfResults) }
        })
        Text("\(vm.artists.count)")
        ScrollView(.vertical) {
            VStack {
                contentView
            }
            .scrollTargetLayout()
        }
        .contentMargins(16, for: .scrollContent)
        .scrollTargetBehavior(.paging)
        .onChange(of: numberOfResults) { oldValue, newValue in
            Task { await vm.fetchArtistWithLimit(query: searchText, limit: numberOfResults)}
        }
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
        Button {
            coordinator.push(.audioPreview(url: artist.previewUrl))
        } label: {
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
                        .lineLimit(1)
                    
                    Text(artist.kind.capitalized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

#Preview {
    HomeView(vm: .init())
}
