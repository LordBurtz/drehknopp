//
//  VolumeObserver.swift
//  drehknopp
//
//  Created by Fridolin Karger on 24.02.25.
//

import Foundation
import MediaPlayer

final class VolumeObserver: ObservableObject {
    
    @Published var volume: CGFloat = CGFloat(AVAudioSession.sharedInstance().outputVolume)
    
    // Audio session object
    private let session = AVAudioSession.sharedInstance()
    
    // Observer
    private var progressObserver: NSKeyValueObservation!
    
    func subscribe() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("cannot activate session")
        }
        
        progressObserver = session.observe(\.outputVolume) { [self] (session, value) in
            DispatchQueue.main.async {
//                print("before: \(self.volume)")
                self.volume = CGFloat(session.outputVolume)
//                print("after: \(self.volume)")
            }
        }
    }
    
    func unsubscribe() {
        self.progressObserver.invalidate()
    }
    
    init() {
        subscribe()
    }
}
