//
//  MetricsView.swift
//  WatchTabata
//
//  Created by Kirill Ushkov on 17.04.2023.
//

import SwiftUI

struct TrainingMetrics: View {
    @Binding var heartRate: Double
    @Binding var distance: Double
    @Binding var energy: Double
    
    var body: some View {
        VStack {
            Text(Measurement(value: energy, unit: UnitEnergy.kilocalories)
                    .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number.precision(.fractionLength(0)))))
            
            Text(heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
            Text(Measurement(value: distance, unit: UnitLength.meters).formatted(.measurement(width: .abbreviated, usage: .road)))

        }
        .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
        .frame(maxWidth: .infinity, alignment: .leading)
        .ignoresSafeArea(edges: .bottom)
        .scenePadding()
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingMetrics(heartRate: .constant(12), distance: .constant(12), energy: .constant(1))
    }
}
