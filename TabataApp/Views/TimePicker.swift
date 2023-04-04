//
//  TimePicker.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 03.04.2023.
//

import UIKit
import SwiftUI

extension Int {
    var minutes: Int {
        self / 60
    }
    
    var seconds: Int {
        self - minutes * 60
    }
}

struct TimePicker: UIViewRepresentable {
    @Binding var selection: Int
        
    func makeCoordinator() -> Coordinator {
        Coordinator(self, selection: selection)
    }
    
    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.delegate = context.coordinator
        picker.dataSource = context.coordinator
        
        picker.selectRow(context.coordinator.timeComponent.selectedMinuteIndex, inComponent: 0, animated: true)
        picker.selectRow(context.coordinator.timeComponent.selectedSecondIndex, inComponent: 1, animated: true)
        return picker
    }
    
    func updateUIView(_ uiView: UIPickerView, context: Context) {}
}

final class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var parent: TimePicker
    var timeComponent: TimeComponent
    
    init(_ parent: TimePicker, selection: Int) {
        self.parent = parent
        self.timeComponent = TimeComponent(durationInSeconds: selection)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeComponent.numberOfRowsIn(component: component)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeComponent.select(component: component, row: row)
        parent.selection = timeComponent.duration
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeComponent.titleFor(component: component, row: row)
    }
}

struct TimeComponent {
    private(set) var selectedMinuteIndex: Int
    private(set) var selectedSecondIndex: Int
    private let minutes = [Int](0..<60)
    private let seconds = [Int](0..<60)
    
    init(durationInSeconds: Int) {
        self.selectedMinuteIndex = minutes.firstIndex(of: durationInSeconds.minutes) ?? 0
        self.selectedSecondIndex = seconds.firstIndex(of: durationInSeconds.seconds) ?? 0
    }
    
    mutating func select(component: Int, row: Int) {
        if component == 0 {
            selectedMinuteIndex = row
        } else {
            selectedSecondIndex = row
        }
    }
    
    func titleFor(component: Int, row: Int) -> String {
        return "\(self[component, row])"
    }
    
    func numberOfRowsIn(component: Int) -> Int {
        return component == 0 ? minutes.count : seconds.count
    }
    
    subscript(component: Int, row: Int) -> Int {
        return component == 0 ? minutes[row] : seconds[row]
    }
    
    var duration: Int {
        minutes[selectedMinuteIndex] * 60 + seconds[selectedSecondIndex]
    }
}

struct TimePicker_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var duration = 631
        var body: some View {
            TimePicker(selection: $duration)
        }
    }
    static var previews: some View {
        Wrapper()
    }
}
