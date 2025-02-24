//
//  ContentView.swift
//  drehknopp
//
//  Created by Fridolin Karger on 20.02.25.
//

import SwiftUI
import CoreMotion
import MediaPlayer
import MusicKit


struct ContentView: View {
    let pi = 3.14159
    let offsetDgr = 60.0
    let multiplier = 1.5
    let angle = 1.07
    
    @State private var isOn = false
    @State private var volObserver = VolumeObserver()
    
    @EnvironmentObject var motion: MotionManager
    
    var normalizedRoll: CGFloat {
        ((motion.fx + angle) / (angle * 2)).clampedTo(0...1)
    }
    
    var tiltPercent: CGFloat {
        if isOn {
            normalizedRoll
        } else {
            volObserver.volume
        }
        
    }
    
    var tiltPercentHalfed: CGFloat {
        tiltPercent / 2
    }
    
    init() {
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    var body: some View {
        VStack {
            topPart
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            bottomPart
                .frame(maxHeight: .infinity)
        }
        .frame(maxHeight: .infinity)
        .background(self.background)
        .padding()
        .onChange(of: tiltPercent, initial: false) { old, new in
            if isOn {
                SystemPlayerBridge.setVolume(Float(new))
            }
        }
        .onAppear() {
            Task {
                try? await SystemPlayerBridge.startPlaybackEventually()
            }
        }
    }
    
    var topPart: some View {
        VStack() {
            Spacer()
            Text(String(format: "%.1f", tiltPercent * 100.0) + " %")
                .font(.largeTitle)
        }
    }
    
    var bottomPart: some View {
        Button(action: {
            isOn = false
        }) {
            Text(isOn ? "Stop" : "Start")
                .font(.headline)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.5))
                }
        }
        .simultaneousGesture(LongPressGesture(minimumDuration: 0.05).onEnded { _ in
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            isOn = true
        })
    }
    
    var background: some View {
        Circle()
            .trim(from: 0, to: tiltPercentHalfed)
            .stroke(Grads.darkPizelex, lineWidth: 30)
            .rotationEffect(Angle(degrees: 180))
            .animation(Animation.linear(duration: 0.1), value: tiltPercentHalfed)
    }
}

#Preview {
    ContentView()
}

struct Grads {
    static let nighthawk: Gradient = .init(colors: [Color("night"), Color("hawk")])
    static let pizelex: Gradient = .init(colors: [Color("pize"), Color("lex")])
    static let darkPizelex: Gradient = .init(colors: [Color("dpize"), Color("dlex"), Color("dpize")])
    
}

struct SystemPlayerBridge {
    static func startPlaybackEventually() async throws {
        try await SystemMusicPlayer.shared.play()
    }
    
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            slider?.value = volume
        }
    }
    
    static func getVolume() -> CGFloat {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        return CGFloat(slider?.value ?? 0)
    }
}
