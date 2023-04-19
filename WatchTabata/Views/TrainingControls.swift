//
//  TrainingControls.swift
//  WatchTabata
//
//  Created by Kirill Ushkov on 17.04.2023.
//

import SwiftUI

struct TrainingControls: View {
    var onPause: () -> Void
    var onResume: () -> Void
    var onStop: () -> Void
    
    @Binding var isSessionRunning: Bool
    
    var body: some View {
        HStack {
            VStack {
                if isSessionRunning {
                    Button {
                        onPause()
                    } label: {
                        Image(systemName: "pause.fill")
                    }
                    .tint(.yellow)
                    .font(.title2)
                    Text("Pause")
                } else {
                    Button {
                        onResume()
                    } label: {
                        Image(systemName: "play.fill")
                    }
                    .tint(.green)
                    .font(.title2)
                    Text("Resume")

                }
            }
            VStack {
                Button {
                    onStop()
                } label: {
                    Image(systemName: "stop.fill")
                }
                .tint(.red)
                .font(.title2)
                Text("Stop")
            }
        }
    }
}

struct TrainingControls_Previews: PreviewProvider {
    static var previews: some View {
        TrainingControls(onPause: {}, onResume: {}, onStop: {}, isSessionRunning: .constant(false))
    }
}
