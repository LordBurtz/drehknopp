//
//  drehknoppApp.swift
//  drehknopp
//
//  Created by Fridolin Karger on 20.02.25.
//

import SwiftUI

@main
struct drehknoppApp: App {
    var body: some Scene {
        WindowGroup {
            let motionManager = MotionManager()
            
            ContentView().environmentObject(motionManager)
        }
    }
}


