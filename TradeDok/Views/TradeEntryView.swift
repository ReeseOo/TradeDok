//
//  TradeEntryView.swift
//  TradeDok
//
//  Created by Reese Oo on 12/21/24.
//

import SwiftUI

struct TradeEntryView: View {

    @State private var ticker: String = ""
    @State private var entryPrice: String = ""
    @State private var exitPrice: String = ""
    @State private var shares: String = ""
    @State private var stopLoss: String = ""
    @State private var date = Date()
    @Binding var tradeEntries: [TradeEntry]

    @FocusState private var focus: FormFieldFocus?
    @Environment(\.dismiss) var dismiss

    // Moved out of the Form body so it's a proper struct property
    var isFormValid: Bool {
        !ticker.isEmpty &&
        Double(entryPrice) != nil &&
        Int(shares) != nil
    }

    var body: some View {
        VStack(spacing: 0) {
            // Sheet header with Cancel and Submit buttons
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Spacer()
                Text("Add Trade")
                    .font(.headline)
                Spacer()
                Button("Submit") {
                    addTradeEntry()
                    dismiss()
                }
                .disabled(!isFormValid)
            }
            .padding()

            Divider()

            Form {
                Section {
                    TextField(text: $ticker, prompt: Text("Required")) {
                        Text("Ticker name")
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit { focus = .entryField }
                    .focused($focus, equals: .tickerField)

                    TextField(text: $entryPrice, prompt: Text("Required")) {
                        Text("Entry price")
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit { focus = .exitField }
                    .focused($focus, equals: .entryField)

                    TextField(text: $exitPrice, prompt: Text("Optional")) {
                        Text("Exit price")
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit { focus = .sharesField }
                    .focused($focus, equals: .exitField)

                    TextField(text: $shares, prompt: Text("Required")) {
                        Text("Shares bought")
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit { focus = .stopField }
                    .focused($focus, equals: .sharesField)

                    TextField(text: $stopLoss, prompt: Text("Optional")) {
                        Text("Stop loss")
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focus, equals: .stopField)

                    DatePicker("Date: ", selection: $date, in: ...Date())
                }
            }
        }
        .frame(width: 420, height: 360)
        .onAppear { focus = .tickerField }
    }

    enum FormFieldFocus: Hashable {
        case tickerField, entryField, exitField, sharesField, stopField
    }

    func addTradeEntry() {
        guard let sharesInt = Int(shares),
              let entryDouble = Double(entryPrice) else { return }

        let newEntry = TradeEntry(
            ticker: ticker,
            shares: sharesInt,
            entry: entryDouble,
            exit: Double(exitPrice),
            stopLoss: Double(stopLoss),
            date: date
        )
        tradeEntries.append(newEntry)

        ticker = ""
        entryPrice = ""
        exitPrice = ""
        shares = ""
        stopLoss = ""
    }
}

#Preview {
    TradeEntryView(tradeEntries: .constant([]))
}
