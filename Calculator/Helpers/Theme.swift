//
//  IdentifiableButtonRow.swift
//  Calculator
//
//  Created by Ataberk Turan on 17/05/2025.
//

import SwiftUI

struct Theme {
    // MARK: - Backgrounds
    static let applicationBackground: Color = Color(.systemBackground)
    static let displayBackgroundColor: Color = .clear

    // MARK: - Text Colors
    static let displayTextColor: Color = Color(.label)
    static let operationButtonTextColor: Color = .white
    static let generalButtonTextColor: Color = Color(.white)

    // MARK: - Button Background Colors
    static let utilityButtonBackgroundColor: Color = Color(.systemGray2)
    static let numberButtonBackgroundColor: Color = Color(.systemGray4)
    static let operationButtonBackgroundColor: Color = .orange

    // MARK: - Button Border
    static let buttonBorderColor: Color = Color(.separator)
    static let buttonStrokeWeight: CGFloat = 1

    static let buttonSpacing: CGFloat = 0

    // MARK: - Helper for button types
    static func backgroundColor(for type: ButtonType) -> Color {
        switch type {
        case .utility:
            return utilityButtonBackgroundColor
        case .operation:
            return operationButtonBackgroundColor
        case .number, .zero, .decimal, .backspace:
            return numberButtonBackgroundColor
        }
    }
    
    static func textColor(for type: ButtonType) -> Color {
        switch type {
        case .operation: // Orange buttons
            return operationButtonTextColor
        default: // Utility, Number, Decimal, Backspace buttons
            return generalButtonTextColor
        }
    }
}
