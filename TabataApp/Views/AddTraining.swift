//
//  AddTraining.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 12.03.2023.
//

import SwiftUI

struct AddTraining: View {
    @ObservedObject var model: TrainingsListModel
    @State private var training = Training(title: "", laps: [], breakBetweenLaps: 0)
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Form {
                TextField("Training Name", text: self.$training.title)
            }
            Button("Save") {
                self.model.addTraining(self.training)
                self.isPresented = false
            }
            .buttonStyle(.borderless)
        }
        .navigationTitle("Add Training")
    }
}

struct AddTraining_Previews: PreviewProvider {
    static var previews: some View {
        AddTraining(model: .mock, isPresented: .constant(true))
    }
}
