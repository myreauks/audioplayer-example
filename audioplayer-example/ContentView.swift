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
    
    init() {
        engine.output = player
        loadFile(filename: "808_Kick_High.wav")
    }
    
    func loadFile(filename: String) {
        player.stop()
        try! player.load(url: (Bundle.main.resourceURL?.appendingPathComponent("Samples/\(filename)"))!, buffered: true)
    }
    
    func startPlayer() {
        player.play()
    }
    
    func stopPlayer() {
        player.stop()
    }
}

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var conductor = PlayerConductor()
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {conductor.startPlayer()}) {
                    Image(systemName: "play.fill")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                Button(action: {conductor.stopPlayer()}) {
                    Image(systemName: "stop.fill")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            Button(action: {conductor.loadFile(filename: "808_Kick_High.wav")}) {
                Text("Change file to stereo")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            
            Button(action: {conductor.loadFile(filename: "mid_tom_B1.wav")}) {
                Text("Change file to mono")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                conductor.start()
                print("Start")
            } else if scenePhase == .background {
                conductor.stop()
                print("Stop")
            }
        }
    }
}

#Preview {
    ContentView()
}
