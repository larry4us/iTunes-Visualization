//
//  ContentView.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 11/08/25.
//

import SwiftUI

struct ContentView: View {
    
    typealias artistSearch = API.Types.Response.ArtistSearch
    @StateObject var vm: MusicViewModel
    @State var searchText = ""
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                SearchBarView(text: $searchText, onSearch: {
                    Task { await vm.fetchArtist(query: searchText) }
                })
                contentView
                    .onAppear {
                        Task {await vm.refresh()}
                    }
            }
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch vm.state {
        case .error(let error):
            Text("houve um erro: \(error)")
        case .loaded:
            VStack{
                Text("\(vm.artists.count)")
                
                ForEach(vm.artists){ artist in
                    artistCard(artist: artist)
                }
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
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView(vm: .init())
}
