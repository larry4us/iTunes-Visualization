//
//  AlbumListView.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 06/10/25.
//

import SwiftUI

struct SpotifyAlbumListView: View {
    
    typealias Response = API.Spotify.Types.Response
    
    // get shared data async from view model
    @StateObject var viewModel: SpotifyAlbumListViewModel
    
    var body: some View {
        NavigationView {
            // get data
            let albumList = viewModel.albumList
            let albumImageUrls = viewModel.albumImageUrls
            // list for albums
            List(Array(zip(albumList, albumImageUrls)), id: \.0) { album, albumImageUrl in
                HStack {
                    // get image with album image url
                    AsyncImage(url: albumImageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 150, height: 150) // mantém placeholder no mesmo tamanho
                    }
                    .frame(width: 150, height: 150)
                    .clipShape(Capsule(style: .continuous))
                    
                    VStack(alignment: .leading, spacing: 10) {
                        if let name = album.name,
                           let albumType = album.albumType,
                           let releaseDate = album.releaseDate,
                           let spotifyUrl = album.externalUrls?.spotify,
                           let totalTracks = album.totalTracks {
                            Text("Name: \(name)").font(.headline)
                            Text("Release Date: \(releaseDate)").font(.subheadline)
                            Text("Total Tracks: \(totalTracks)").font(.subheadline)
                            Link("go to \(albumType)", destination: URL(string: spotifyUrl)!)
                        }
                    }.padding(.init(top: 12, leading: 0, bottom: 12, trailing: 0))
                }.padding(.init(top: 12, leading: 0, bottom: 12, trailing: 0))
            }.onAppear {
                // fire the data transactions
                viewModel.getData()
            }.navigationBarTitle("Álbuns do Don L")
        }
    }
}

#Preview {
    SpotifyAlbumListView(viewModel: .init())
}
