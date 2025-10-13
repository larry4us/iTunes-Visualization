//
//  MainCoordinatorView.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 13/10/25.
//

import SwiftUI

struct MainCoordinatorView: View {
    
    @StateObject private var coordinator = Coordinator()
    @State private var selectedTab: Tab = .spotify
    
    enum Tab {
        case spotify
        case itunes
        case settings
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // MARK: - Spotify Tab
            NavigationStack(path: $coordinator.path) {
                coordinator.build(page: .spotifyHome)
                    .navigationDestination(for: Page.self) { page in
                        coordinator.build(page: page)
                    }
                    
            }
            .tabItem {
                Label("Spotify", systemImage: "music.note.list")
            }
            .tag(Tab.spotify)
            
            // MARK: - iTunes Tab
            NavigationStack {
                coordinator.build(page: .iTunesHome)
            }
            .tabItem {
                Label("iTunes", systemImage: "music.note")
            }
            .tag(Tab.itunes)
        }
        .tint(selectedTab == .spotify ? .green : .red.mix(with: .white, by: 0.2))
        .environmentObject(coordinator)
    }
}
