//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Ataberk Turan on 13/05/2025.
//

import SwiftUI
import SwiftData

@main
struct CalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                CalculatorView()
            }
            .navigationViewStyle(.stack)
        }
        .modelContainer(for: [CalculationHistory.self])
    }
}

