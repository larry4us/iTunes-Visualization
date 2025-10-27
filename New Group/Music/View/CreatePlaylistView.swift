//
//  CreatePlaylistView.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 20/10/25.
//

import SwiftUI

struct CreatePlaylistView: View {
    
    @StateObject var vm: SpotifyAlbumListViewModel
    
    var body: some View {

        Button(action: {
            Task {
                await vm.createNewPlaylist(named: "NOVA PLAYLISTT")
            }
        }) {
            Circle()
        }
        
    }
}

#Preview {
    CreatePlaylistView(vm: .init())
}
