//
//  MusicApp.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 11/08/25.
//

import SwiftUI

@main
struct MusicApp: App {

    var body: some Scene {
        WindowGroup {
            // MainCoordinatorView()
            UIKitSceneWrapper()
        }
    }
}

struct UIKitSceneWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let delegate = SceneDelegate()
        let viewController = delegate.rootViewController
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
