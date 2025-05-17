//
//  IdentifiableButtonRow.swift
//  Calculator
//
//  Created by Ataberk Turan on 17/05/2025.
//

import SwiftUI

struct CalculatorButton: View {
    
    // MARK: - Properties
    let label: String
    let buttonType: ButtonType
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(Theme.textColor(for: buttonType))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Theme.backgroundColor(for: buttonType))
                .overlay(
                    Rectangle()
                        .stroke(Theme.buttonBorderColor, lineWidth: Theme.buttonStrokeWeight)
                )
        }
    }
}

// MARK: - Previews
#Preview {
    VStack {
        CalculatorButton(label: "AC", buttonType: .utility) {}
            .frame(width: 80, height: 80)
        CalculatorButton(label: "7", buttonType: .number) {}
            .frame(width: 80, height: 80)
        CalculatorButton(label: "+", buttonType: .operation) {}
            .frame(width: 80, height: 80)
        CalculatorButton(label: "􀆛", buttonType: .backspace) {}
            .frame(width: 80, height: 80)
    }
    .padding()
    .background(Color.gray)
} 
