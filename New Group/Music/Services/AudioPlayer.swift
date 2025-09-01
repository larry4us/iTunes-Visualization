//
//  AudioPlayer.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 01/09/25.
//

import Foundation
import AVFoundation

// Usamos ObservableObject para que a UI em SwiftUI possa reagir a mudanças (ex: isPlaying)
class AudioPlayerService: ObservableObject {

    static let shared = AudioPlayerService()
    
    private var player: AVPlayer?
    
    // A propriedade @Published notifica a UI sempre que seu valor muda
    @Published var isPlaying = false

    private init() {}

    func play(url: URL) {
        // Se já estiver tocando a mesma URL, não faz nada
        if isPlaying, let currentItemURL = (player?.currentItem?.asset as? AVURLAsset)?.url, currentItemURL == url {
            return
        }

        // Configura a sessão de áudio do app
        // Essencial para garantir que o som toque mesmo com o modo silencioso ativado
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("❌ Falha ao configurar a sessão de áudio: \(error.localizedDescription)")
        }
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        isPlaying = true
        
        // Adiciona um observador para saber quando a música terminou
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func togglePlayPause(url: URL) {
        if isPlaying {
            pause()
        } else {
            play(url: url)
        }
    }
    
    @objc private func playerDidFinishPlaying(note: NSNotification) {
        // A preview terminou, então resetamos o estado
        self.isPlaying = false
    }
    
    // Limpeza do observador
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
