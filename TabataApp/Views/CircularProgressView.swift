//
//  CircularProgressView.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 13.03.2023.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let tintColor: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    tintColor.opacity(0.5),
                    lineWidth: 30
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    tintColor,
                    style: StrokeStyle(
                        lineWidth: 30,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                // 1
                .animation(.easeOut, value: progress)

        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    struct ContentView: View {
        // 1
        @State var progress: Double = 0
        
        var body: some View {
            VStack {
                Spacer()
                ZStack {
                    Text("\(progress * 100, specifier: "%.0f")")
                        .font(.largeTitle)
                        .bold()
                    CircularProgressView(progress: progress, tintColor: .pink)
                }
                Spacer()
                HStack {
                    // 4
                    Slider(value: $progress, in: 0...1)
                    // 5
                    Button("Reset") {
                        resetProgress()
                    }.buttonStyle(.borderedProminent)
                }
            }
        }
        
        func resetProgress() {
            progress = 0
        }
    }

    static var previews: some View {
        ContentView()
    }
}
