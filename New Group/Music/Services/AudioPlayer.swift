//
//  AudioPlayer.swift
//  Music
//
//  Created by Pedro Larry Rodrigues Lopes on 01/09/25.
//

import Foundation
import AVFoundation

class AudioPlayerService: ObservableObject {

    static let shared = AudioPlayerService()
    
    var player: AVPlayer?
    
    @Published var isPlaying = false
    @Published var isLoading = false // Novo estado para carregamento

    private init() {}

    func play(url: URL) {
        // Se já estiver tocando a mesma URL, não faz nada
        if isPlaying, let currentItemURL = (player?.currentItem?.asset as? AVURLAsset)?.url, currentItemURL == url {
            return
        }
        
        // Se está tocando outra música, pausa antes de iniciar uma nova
        if isPlaying {
            pause()
        }

        isLoading = true // Indica que o áudio está sendo carregado
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("❌ Falha ao configurar a sessão de áudio: \(error.localizedDescription)")
            isLoading = false
            return
        }
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        // Adiciona um observador para saber quando o player está pronto para tocar
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachReadyToPlay),
                                               name: .AVPlayerItemNewErrorLogEntry, // Usaremos um método diferente para saber quando está pronto
                                               object: playerItem)

        // Observa quando o item terminou de tocar
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
        
        player?.play()
        // O isPlaying só será true quando estiver realmente tocando (no playerItemDidReachReadyToPlay)
    }

    func pause() {
        player?.pause()
        isPlaying = false
        isLoading = false
        // Remove o observador de término se pausado manualmente, para evitar chamadas duplas
        if let playerItem = player?.currentItem {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        }
    }
    
    func togglePlayPause(url: URL) {
        if isPlaying {
            pause()
        } else {
            play(url: url)
        }
    }
    
    @objc private func playerDidFinishPlaying(note: NSNotification) {
        self.isPlaying = false
        self.isLoading = false
        // Remove o observador após o término
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: note.object)
    }
    
    // Novo método para verificar quando o item está pronto para tocar
    @objc private func playerItemDidReachReadyToPlay(notification: Notification) {
        // Isso é um placeholder. AVPlayer não tem um .readyToPlay direto na notificação.
        // O AVPlayer começa a tocar assim que dados suficientes são bufferizados.
        // Para uma preview, isso geralmente acontece muito rápido.
        // Se você precisar de um indicador de "ready", precisaria observar `status` do AVPlayerItem.
        // Para simplicidade, vamos assumir que `play()` é suficiente e que `isLoading` pode ser desligado logo depois.
        self.isPlaying = true
        self.isLoading = false
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
