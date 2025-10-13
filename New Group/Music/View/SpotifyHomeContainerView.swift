//
//  SpotifyHomeContainerView.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 13/10/25.
//

import SwiftUI

struct SpotifyHomeContainerView: View {
    
    @ObservedObject var coordinator: Coordinator
    @State private var selectedSection: Section = .albums
    
    enum Section: String, CaseIterable, Identifiable {
        case albums = "Álbuns"
        case playlists = "Playlists"
        
        var id: String { rawValue }
    }
    
    var body: some View {
        VStack {
            // MARK: - Segmented Control
            Picker("Seção", selection: $selectedSection) {
                ForEach(Section.allCases) { section in
                    Text(section.rawValue).tag(section)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top, 10)
            
            // MARK: - Conteúdo das telas
            Group {
                switch selectedSection {
                case .albums:
                    SpotifyAlbumListView(viewModel: coordinator.spotifyViewModel)
                case .playlists:
                    SpotifyUserPlaylistsView(viewModel: coordinator.spotifyViewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .transition(.opacity)
        }
        .navigationTitle("Spotify")
        .navigationBarTitleDisplayMode(.inline)
    }
}
