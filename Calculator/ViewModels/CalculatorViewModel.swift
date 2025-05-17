//
//  IdentifiableButtonRow.swift
//  Calculator
//
//  Created by Ataberk Turan on 17/05/2025.
//

import Foundation
import SwiftUI

@Observable
class CalculatorViewModel {
    
    // MARK: - Properties
    private(set) var currentNumber: String = "0"
    private(set) var elements: [CalculatorElement] = []
    private var shouldResetNumber: Bool = false
    
    var displayText: String {
        currentNumber
    }
    
    // MARK: - Methods
    
    func inputDigit(_ digit: String) {
        if shouldResetNumber {
            currentNumber = digit
            shouldResetNumber = false
        } else {
            if currentNumber == "0" {
                currentNumber = digit
            } else {
                currentNumber += digit
            }
        }
    }
    
    func inputDecimal() {
        if shouldResetNumber {
            currentNumber = "0."
            shouldResetNumber = false
        } else if !currentNumber.contains(".") {
            currentNumber += "."
        }
    }
    
    func inputOperation(_ operation: CalculatorOperator) {
        if let number = Double(currentNumber) {
            if let lastElement = elements.last {
                if case .operation = lastElement {
                    if elements.count > 1 {
                        elements.removeLast()
                    } else {
                        return
                    }
                }            
            }
            elements.append(.number(number))
            elements.append(.operation(operation))
            shouldResetNumber = true
        } else if operation == .subtract && currentNumber == "0" && elements.isEmpty {
            currentNumber = "-"
            shouldResetNumber = false
        }
    }
    
    func calculate() -> (expression: String, result: String)? {
        guard let number = Double(currentNumber) else { return nil }
        elements.append(.number(number))
        
        guard !elements.isEmpty else { return nil }

        var currentResult: Double = 0
        var lastNumber: Double? = nil
        var activeOperator: CalculatorOperator? = nil

        guard case .number(let firstNum) = elements.first else {
            print("Calculation error: Expression does not start with a number.")
            elements.removeAll()
            currentNumber = "0"
            shouldResetNumber = true
            return nil
        }
        currentResult = firstNum
        lastNumber = firstNum
        
        var expressionString = ""
        expressionString += formatNumber(firstNum)

        for i in 1..<elements.count {
            let element = elements[i]
            switch element {
            case .number(let num):
                if let op = activeOperator {
                    expressionString += " \(op.rawValue) " + formatNumber(num)
                    switch op {
                    case .add:
                        currentResult += num
                    case .subtract:
                        currentResult -= num
                    case .multiply:
                        currentResult *= num
                    case .divide:
                        if num != 0 {
                            currentResult /= num
                        } else {
                            self.elements.removeAll()
                            self.currentNumber = "Error"
                            self.shouldResetNumber = true
                            return (expression: expressionString + " = Error", result: "Error")
                        }
                    case .power:
                        currentResult = pow(currentResult, num)
                    case .percent:
                        currentResult = currentResult * (num / 100)
                    }
                    activeOperator = nil
                } else {
                }
                lastNumber = num
            case .operation(let op):
                activeOperator = op
            }
        }
        
        let finalResultString = formatNumber(currentResult)
        let finalExpressionString = expressionString

        currentNumber = finalResultString
        elements = []
        shouldResetNumber = true
        
        return (expression: finalExpressionString + " = " + finalResultString, result: finalResultString)
    }

    private func formatNumber(_ number: Double) -> String {
        if number.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", number)
        } else {
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 5
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: number)) ?? String(number)
        }
    }
    
    func clear() {
        currentNumber = "0"
        elements = []
        shouldResetNumber = false
    }
    
    func toggleSign() {
        if currentNumber == "Error" { return }
        if currentNumber.hasPrefix("-") {
            currentNumber.removeFirst()
        } else if currentNumber != "0" {
            currentNumber = "-" + currentNumber
        }
    }
    
    func percentage() {
        if let number = Double(currentNumber) {
            currentNumber = formatNumber(number / 100)
        }
    }
    
    func backspace() {
        if currentNumber == "Error" { currentNumber = "0"; return}
        if !currentNumber.isEmpty && currentNumber != "0" {
            currentNumber.removeLast()
            if currentNumber.isEmpty || currentNumber == "-" {
                currentNumber = "0"
            }
        } else {
            currentNumber = "0"
        }
    }
} 
