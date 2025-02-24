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
    
    @State private var isOn = true
    @State private var volObserver = VolumeObserver()
    
    @EnvironmentObject var motion: MotionManager
    
    var rawFillDegree: CGFloat {
        motion.fx * (180 / pi)
    }
    
    var adjustedFillDegree: CGFloat {
        !isOn ? systemFillDegree :
            rawFillDegree * multiplier + offsetDgr
    }
    
    var fillPercent: CGFloat {
        min(0.5, adjustedFillDegree / 360)
    }
    
    var fillPercentOf180: CGFloat {
        min(1.0, adjustedFillDegree / 180)
    }
    
    var systemFillDegree: CGFloat {
        volObserver.volume * 360
    }
    
    init() {
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Text(String(format: "%.1f", fillPercentOf180 * 100.0) + " %")
                        .font(.largeTitle)
                    Button(action: {
                        isOn = !isOn
                    }) {
                        
                    }
                }
            }
            .padding()
            
            Circle()
                .trim(from: 0, to: fillPercent)
                .stroke(Grads.darkPizelex, lineWidth: 30)
                .rotationEffect(Angle(degrees: 180))
                .animation(Animation.linear(duration: 0.1), value: fillPercent)
        }
        .padding()
        .onChange(of: fillPercentOf180, initial: false) { old, new in
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
