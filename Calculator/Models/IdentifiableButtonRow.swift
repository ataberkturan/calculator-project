//
//  IdentifiableButtonRow.swift
//  Calculator
//
//  Created by Ataberk Turan on 17/05/2025.
//

import SwiftUI

struct IdentifiableButtonRow: Identifiable {
    let id: String
    let buttons: [(label: String, type: ButtonType, sfSymbol: String?, action: (CalculatorViewModel) -> Void)]

    init(buttons: [(label: String, type: ButtonType, sfSymbol: String?, action: (CalculatorViewModel) -> Void)]) {
        self.buttons = buttons
        self.id = buttons.map { $0.label }.joined(separator: "-") // Ensure unique ID
    }
}
