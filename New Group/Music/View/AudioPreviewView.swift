//
//  AudioPreviewView.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 01/09/25.
//

import SwiftUI

struct AudioPreviewView: View {
    // A URL da preview que você recebe do JSON da API do iTunes
       let previewUrlString: String
       
       // Injeta nosso serviço de áudio na View
       @StateObject private var audioPlayer = AudioPlayerService.shared

       var body: some View {
           // Tenta criar um objeto URL a partir da string
           if let previewUrl = URL(string: previewUrlString) {
               Button(action: {
                   // Ação do botão: chama a função de toggle
                   audioPlayer.togglePlayPause(url: previewUrl)
               }) {
                   Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                       .resizable()
                       .aspectRatio(contentMode: .fit)
                       .frame(width: 50, height: 50)
                       .foregroundColor(.accentColor)
               }
           } else {
               // Mostra um ícone de erro se a URL for inválida
               Image(systemName: "xmark.circle.fill")
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .frame(width: 50, height: 50)
                   .foregroundColor(.red)
                   .onAppear {
                       print("URL da preview inválida: \(previewUrlString)")
                   }
           }
       }
}

struct ContentView2: View {
    // Simula o dado recebido da API
       let trackPreviewUrl = "http://a1099.itunes.apple.com/r10/Music/f9/54/43/mzi.gqvqlvcq.aac.p.m4p"
       
       var body: some View {
           VStack {
               Text("Preview da Música")
                   .font(.title)
               
               AudioPreviewView(previewUrlString: trackPreviewUrl)
           }
       }
}

#Preview {
    ContentView2()
}
