//
//  MotionManager.swift
//  drehknopp
//
//  Created by Fridolin Karger on 20.02.25.
//

import CoreMotion
import SwiftUICore

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    
    var fx: CGFloat = 0
    var fy: CGFloat = 0
    var fz: CGFloat = 0

    var dx: Double = 0
    var dy: Double = 0
    var dz: Double = 0
    
    var normalizedRoll: CGFloat {
        ((fx + 1.4) / 2.8).clampedTo(0...1)
    }
    
    init() {
        motionManager.startDeviceMotionUpdates(to: .main) { data, error in
            guard let attitude = data?.attitude else { return }
            
            self.dx = attitude.roll
//            print("dx: \(self.dx)")
            self.dy = attitude.pitch
            self.dz = attitude.yaw

            self.fx = CGFloat(attitude.roll)
            self.fy = CGFloat(attitude.pitch)
            self.fz = CGFloat(attitude.yaw)

            self.objectWillChange.send()
        }
    }
    
    func shutdown() {
        motionManager.stopDeviceMotionUpdates()
    }
}

extension CGFloat {
    func clampedTo(_ range: ClosedRange<CGFloat>) -> CGFloat {
        return Self.minimum(Self.maximum(self, range.lowerBound), range.upperBound)
    }
}
