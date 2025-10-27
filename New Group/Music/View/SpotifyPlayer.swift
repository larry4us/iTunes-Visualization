//
//  SpotifyPlayer.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 27/10/25.
//

import UIKit
import SwiftUI

struct Spotify: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        let vc = ViewController()
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct ContentView: View {
    var body: some View {
        VStack {
            Spotify()
        }
    }
}

#Preview {
    ContentView()
}
