
//  ContentView.swift
//  audioplayertest


import SwiftUI
import AVFoundation
import AudioKit

class PlayerConductor: ObservableObject, HasAudioEngine {
    
    let engine = AudioEngine()
    let mixer = Mixer()
    
    var audioFile: AVAudioFile?
    
    var player = AudioPlayer()
    
    init(file: String) {
        
        guard let url = Bundle.main.resourceURL?.appendingPathComponent("Samples/\(file)") else { return }
        do {
            
            audioFile = try AVAudioFile(forReading: url)
            
            try player.load(url: url, buffered: true)
            
            print("Channel count for AVAudioPlayerNode")
            print(player.playerNode.outputFormat(forBus: 0).channelCount)
            
        } catch {
            Log("Could not load: \(file)")
        }
        
        engine.output = mixer
        
        mixer.addInput(player)
        mixer.addInput(player)
    }
    
    func loadFile(filename: String) {
        guard let url = Bundle.main.resourceURL?.appendingPathComponent("Samples/\(filename)"),
              let buffer = try? AVAudioPCMBuffer(url: url)
        else {
            Log("failed to load sample", filename)
            return
        }
        self.player.stop()
        self.player.file = try? AVAudioFile(forReading: url)
        self.player.buffer = buffer
        print("Channel count for AVAudioPlayerNode")
        print(player.playerNode.outputFormat(forBus: 0).channelCount)
    }
    
    func play() {
        player.play()
    }
    
    func stop() {
        player.stop()
    }
}

struct ContentView: View {
    @StateObject var conductor = PlayerConductor(file: "clap_mono.wav")
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {conductor.play()}) {
                    Image(systemName: "play.fill")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                Button(action: {conductor.stop()}) {
                    Image(systemName: "stop.fill")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            Button(action: {conductor.loadFile(filename: "clap_stereo.wav")}) {
                Text("Change file to stereo")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
        .onAppear {
            conductor.start()
        }
        .onDisappear {
            conductor.stop()
        }
    }
}

#Preview {
    ContentView()
}
