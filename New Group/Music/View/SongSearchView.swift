//
//  ContentView.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 11/08/25.
//

import SwiftUI

struct SongSearchView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    
    typealias artistSearch = API.Types.Response.SongSearch
    
    let columns = Array(repeating: GridItem(.flexible(minimum: 50)), count: 2)
    
    @StateObject var vm: MusicViewModel
    @State var searchText = ""
    
    var body: some View {
        SearchBarView(text: $searchText, numberOfResults: $vm.numberOfResults, onSearch: {
            Task { await vm.fetchSongsWithLimit(query: searchText, limit: vm.numberOfResults) }
        })
        Text("\(vm.songs.count)")
        ScrollView(.vertical) {
            VStack {
                contentView
            }
            .scrollTargetLayout()
        }
        .contentMargins(16, for: .scrollContent)
        .scrollTargetBehavior(.paging)
        .onChange(of: vm.numberOfResults) { _ , _ in
            Task { await vm.refresh()}
        }
    } 
    
    @ViewBuilder
    var contentView: some View {
        switch vm.state {
        case .error(let error):
            Text("houve um erro: \(error)")
        case .loaded:
            ForEach(vm.songs){ artist in
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
                    Text(artist.trackName)
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
    SongSearchView(vm: .init())
}
