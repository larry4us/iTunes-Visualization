//
//  Coordinator.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 01/09/25.
//

import Foundation
import SwiftUI

enum Page: Hashable {
    case iTunesHome
    case audioPreview(url: String)
    case spotifyHome
}

class Coordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    
    let spotifyViewModel: SpotifyAlbumListViewModel = .init()
    let viewmodel: MusicViewModel = .init()
    
    func push(_ page: Page){
        path.append(page)
    }
    
    func pop(){
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .iTunesHome:
            SongSearchView(vm: self.viewmodel)
        case .audioPreview(let url):
            AudioPreviewView(previewUrlString: url)
        case .spotifyHome:
            SpotifyHomeContainerView(coordinator: self)
        }
    
    }
}
