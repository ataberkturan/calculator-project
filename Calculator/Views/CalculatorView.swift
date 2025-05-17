//
//  IdentifiableButtonRow.swift
//  Calculator
//
//  Created by Ataberk Turan on 17/05/2025.
//

import SwiftUI
import SwiftData

struct CalculatorView: View {
    
    // MARK: - Properties
    @State private var viewModel = CalculatorViewModel()
    @State private var showingHistory = false
    @Environment(\.modelContext) private var modelContext
    
    private let buttonRows: [IdentifiableButtonRow] = [
        IdentifiableButtonRow(buttons: [
            ("AC", .utility, nil, { $0.clear() }),
            ("±", .utility, "plus.forwardslash.minus", { $0.toggleSign() }),
            ("%", .utility, "percent", { $0.percentage() }),
            ("÷", .operation, "divide", { $0.inputOperation(.divide) })
        ]),
        IdentifiableButtonRow(buttons: [
            ("7", .number, nil, { $0.inputDigit("7") }),
            ("8", .number, nil, { $0.inputDigit("8") }),
            ("9", .number, nil, { $0.inputDigit("9") }),
            ("×", .operation, "multiply", { $0.inputOperation(.multiply) })
        ]),
        IdentifiableButtonRow(buttons: [
            ("4", .number, nil, { $0.inputDigit("4") }),
            ("5", .number, nil, { $0.inputDigit("5") }),
            ("6", .number, nil, { $0.inputDigit("6") }),
            ("-", .operation, "minus", { $0.inputOperation(.subtract) })
        ]),
        IdentifiableButtonRow(buttons: [
            ("1", .number, nil, { $0.inputDigit("1") }),
            ("2", .number, nil, { $0.inputDigit("2") }),
            ("3", .number, nil, { $0.inputDigit("3") }),
            ("+", .operation, "plus", { $0.inputOperation(.add) })
        ]),
        IdentifiableButtonRow(buttons: [
            ("􀆛", .backspace, "delete.left", { $0.backspace() }),
            ("0", .zero, nil, { $0.inputDigit("0") }),
            (",", .decimal, nil, { $0.inputDecimal() }),
            ("=", .operation, "equal", { vm in
                if let calcData = vm.calculate() {}
            })
        ])
    ]
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: Theme.buttonSpacing) {
                // Display
                display(geometry: geometry)
                // Buttons Stack
                buttons(geometry: geometry)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.applicationBackground)
            .edgesIgnoringSafeArea(.bottom)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingHistory = true }) {
                    Image(systemName: "clock")
                }
            }
        }
        .sheet(isPresented: $showingHistory) {
            HistoryView()
        }
    }
}

// MARK: - Helper Views
extension CalculatorView {
    func display(geometry: GeometryProxy) -> some View {
        HStack {
            Spacer()
            Text(viewModel.displayText)
                .font(.system(size: displayFontSize(for: geometry.size.height / 6), weight: .light))
                .foregroundColor(Theme.displayTextColor)
                .padding()
                .lineLimit(1)
                .minimumScaleFactor(0.3)
                .frame(height: geometry.size.height / 5)
        }
        .background(Theme.displayBackgroundColor)
    }
    
    func buttons(geometry: GeometryProxy) -> some View {
        ForEach(buttonRows) { identifiableRow in
            HStack(spacing: Theme.buttonSpacing) {
                ForEach(identifiableRow.buttons, id: \.label) { buttonInfo in
                    let currentButtonWidth = geometry.size.width / CGFloat(identifiableRow.buttons.count)
                    let dynamicFontSize = buttonFontSize(for: currentButtonWidth)

                    CalculatorButton(
                        label: buttonInfo.sfSymbol != nil ? "" : buttonInfo.label,
                        buttonType: buttonInfo.type,
                        action: {
                            if buttonInfo.label == "=" {
                                if let calcData = viewModel.calculate() {
                                    saveCalculation(expression: calcData.expression, result: calcData.result)
                                }
                            } else {
                                buttonInfo.action(viewModel)
                            }
                        }
                    )
                    .overlay(
                        buttonInfo.sfSymbol.map { Image(systemName: $0)
                            .font(.system(size: dynamicFontSize, weight: .medium))
                            .foregroundColor(Theme.textColor(for: buttonInfo.type))}
                    )
                    .frame(width: currentButtonWidth,
                           height: (geometry.size.height * 4 / 5) / CGFloat(buttonRows.count))
                }
            }
        }
    }
}

// MARK: - Helper Methods
extension CalculatorView {
    private func displayFontSize(for height: CGFloat) -> CGFloat {
        return max(24, min(height * 0.8, 96))
    }
    
    private func buttonFontSize(for buttonSize: CGFloat) -> CGFloat {
        return max(16, buttonSize * 0.4)
    }

    func saveCalculation(expression: String, result: String) {
        let historyEntry = CalculationHistory(expression: expression, result: result, timestamp: Date())
        modelContext.insert(historyEntry)
    }
}

// MARK: - Previews
#Preview {
    NavigationView {
        CalculatorView()
    }
    .modelContainer(for: [CalculationHistory.self], inMemory: true)
} 
