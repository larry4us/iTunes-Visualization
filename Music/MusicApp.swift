//
//  MusicApp.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 11/08/25.
//

import SwiftUI

@main
struct MusicApp: App {
    
    let vm: MusicViewModel = .init()
    
    var body: some Scene {
        WindowGroup {
            ContentView(vm: vm)
        }
    }
}
