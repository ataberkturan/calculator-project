//
//  IdentifiableButtonRow.swift
//  Calculator
//
//  Created by Ataberk Turan on 17/05/2025.
//

import Foundation
import SwiftData

enum CalculatorOperator: String {
    case add = "+"
    case subtract = "−"
    case multiply = "×"
    case divide = "÷"
    case power = "^"
    case percent = "%"
    
    var precedence: Int {
        switch self {
        case .add, .subtract:
            return 1
        case .multiply, .divide:
            return 2
        case .power:
            return 3
        case .percent:
            return 4
        }
    }
}

enum CalculatorElement {
    case number(Double)
    case operation(CalculatorOperator)
}

@Model
final class CalculationHistory {
    @Attribute(.unique) var id: UUID = UUID()
    var expression: String
    var result: String
    var timestamp: Date

    init(expression: String, result: String, timestamp: Date = Date()) {
        self.expression = expression
        self.result = result
        self.timestamp = timestamp
    }
} 
