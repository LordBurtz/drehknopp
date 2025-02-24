//
//  OnOffButton.swift
//  drehknopp
//
//  Created by Fridolin Karger on 23.02.25.
//

import SwiftUI

struct OnOffButton: View {
    @Binding var isOn: Bool
    let action: () -> Void
    
    var tint: Color = .night
    var textOn = "On"
    var textOff = "Off"
    
    var font: Font {
        .system(size: 30)
    }
    
    var body: some View {
        Button (action: action) {
            ZStack {
                Text(textOff)
                    .font(font)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .foregroundStyle(.white)
                    .background(RoundedRectangle(cornerRadius: 8).fill(tint))
                
                Text(textOn)
                    .font(font)
                    .foregroundStyle(.white)
                    .opacity(isOn ? 1 : 0)
                    .animation(.spring(duration: 0.5), value: isOn)
                
                
                
            }
        }
    }
}

#Preview {
    struct Preview: View {
        @State var isOn1 = false
        @State var isOn2 = true
        var body: some View {
            VStack {
                OnOffButton(isOn: $isOn1) {
                    isOn1 = !isOn1
                }
                Spacer()
                    .frame(height: 40)
                OnOffButton(isOn: $isOn2) {
                    isOn2 = !isOn2
                }
            }
        }
    }

    return Preview()
}
