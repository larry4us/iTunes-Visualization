//
//  SearchBarView.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 25/08/25.
//

import SwiftUI

struct SearchBarView: View {
    // Binding para o texto que o usuário digita.
    // A tela principal terá a "fonte da verdade".
    @Binding var text: String
    
    // Ação a ser executada quando a busca for submetida (pressionar "return").
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            // Ícone de Lupa
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)

            // Campo de Texto
            TextField("Buscar artistas...", text: $text)
                .onSubmit {
                    onSearch()
                }
                .keyboardType(.webSearch)

            // Botão de Limpar (só aparece se houver texto)
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
