//
//  MoveButton.swift
//  drehknopp
//
//  Created by Fridolin Karger on 23.02.25.
//

import SwiftUI

struct MoveButton: View {
    @State var showingSubview = false

    var body: some View {
        VStack {
            Button("Show Subview") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showingSubview.toggle()
                }
            }
            

            if showingSubview {
                Text("Subview")
                    .padding()
                    .background(Color.green)
            }
        }
        .padding()
        .background(Color.yellow)
        .clipped()
        .scaleEffect(1)
        .offset(x: 0, y: showingSubview ? 0 : 0)
    }
}

#Preview {
    MoveButton()
}
