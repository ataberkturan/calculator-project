//
//  IdentifiableButtonRow.swift
//  Calculator
//
//  Created by Ataberk Turan on 17/05/2025.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CalculationHistory.timestamp, order: .reverse)
    private var history: [CalculationHistory]
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            if history.isEmpty {
                ContentUnavailableView {
                    Label("No History", systemImage: "list.bullet.rectangle.portrait")
                } description: {
                    Text("Your calculations will appear here once you perform them.")
                }
                .navigationTitle("History")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            } else {
                List {
                    ForEach(history) { entry in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.expression)
                                .font(.headline)
                            Text("= \(entry.result)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(entry.timestamp, style: .time)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deleteHistoryEntry)
                }
                .navigationTitle("History")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Clear All") {
                            deleteAllHistory()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Helper Methods
extension HistoryView {
    private func deleteHistoryEntry(offsets: IndexSet) {
        withAnimation {
            offsets.map { history[$0] }.forEach(modelContext.delete)
            // Explicit save after individual delete if needed, though autosave is common
            // try? modelContext.save()
        }
    }
    
    private func deleteAllHistory() {
        try? modelContext.delete(model: CalculationHistory.self)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context after deleting all history: \(error)")
        }
    }
}

// MARK: - Previews
#Preview {
    HistoryView()
        .modelContainer(for: CalculationHistory.self, inMemory: true)
}

#Preview("With History Data") {
    let container = try! ModelContainer(for: CalculationHistory.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let sampleHistory = [
        CalculationHistory(expression: "2 + 2 = 4", result: "4", timestamp: Date().addingTimeInterval(-3600)),
        CalculationHistory(expression: "10 * 5 = 50", result: "50", timestamp: Date().addingTimeInterval(-1800)),
        CalculationHistory(expression: "100 / 4 = 25", result: "25", timestamp: Date())
    ]
    sampleHistory.forEach { container.mainContext.insert($0) }
    
    return HistoryView()
        .modelContainer(container)
} 
