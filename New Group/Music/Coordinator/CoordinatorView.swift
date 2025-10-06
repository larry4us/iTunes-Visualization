//
//  CoordinatorView.swift
//  CookiesOnCloud
//
//  Created by Pedro Larry Rodrigues Lopes on 29/07/25.
//

import Foundation
import SwiftUI

struct CoordinatorView: View {
    
    @StateObject var coordinator = Coordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .home)
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                }
        }
        .environmentObject(coordinator)
    }
}

