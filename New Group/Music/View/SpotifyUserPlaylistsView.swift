//
//  SpotifyUserPlaylistsView.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 13/10/25.
//

import SwiftUI

struct SpotifyUserPlaylistsView: View {
    
    typealias Response = API.Spotify.Types.Response
    @StateObject var viewModel: SpotifyAlbumListViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.playlists, id: \.id) { playlist in
                HStack(alignment: .center, spacing: 16) {
                    // Capa da playlist
//                    AsyncImage(url: playlist.images.first?.url.flatMap(URL.init)) { image in
//                        image
//                            .resizable()
//                            .aspectRatio(1, contentMode: .fit)
//                    } placeholder: {
//                        ProgressView()
//                            .frame(width: 80, height: 80)
//                    }
//                    .frame(width: 80, height: 80)
//                    .clipShape(RoundedRectangle(cornerRadius: 12))
//                    .shadow(radius: 4)
                    
                    // Informações
                    VStack(alignment: .leading, spacing: 6) {
                        Text(playlist.name)
                            .font(.headline)
                            .lineLimit(1)
                        
                        Text("Por \(playlist.owner.displayName)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text("\(playlist.tracks.total) músicas")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Link("Abrir no Spotify", destination: URL(string: playlist.externalUrls.spotify)!)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Playlists de Usuário")
            .onAppear {
                // Garante que estamos assinados e dados estão carregados
                viewModel.getData()
            }
        }
    }
}

#Preview {
    SpotifyUserPlaylistsView(viewModel: .init())
}
