//
//  EditTradeEntryView.swift
//  TradeDok
//
//  Created by Reese Oo on 12/24/24.
//

import SwiftUI

struct EditTradeEntryView: View {
    
    @State private var newTicker: String = ""
    @State private var newEntryPrice: String = ""
    @State private var newExitPrice: String = ""
    @State private var newShares: String = ""
    @State private var newStopLoss: String = ""
    @State private var newDate = Date()
    @Binding var tradeEntries: [TradeEntry]
    @Binding var editingTradeID: TradeEntry.ID? // Variable receives given tradeID argument.
    
    
    var trade: Binding<TradeEntry>? { // Takes the tradeID and finds the trade itself.
            guard let index = tradeEntries.firstIndex(where: { $0.id == editingTradeID }) else { return nil }
            return $tradeEntries[index]
        }
    
    @FocusState private var focus: FormFieldFocus?
    @Environment(\.dismiss) var dismiss

    let currencyStyle = FloatingPointFormatStyle<Double>.Currency(code: "USD")

    
    var body: some View {
        
        VStack(spacing: 0) {
            // Sheet header with Cancel and Submit buttons
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Spacer()
                Text("Edit Trade")
                    .font(.headline)
                Spacer()
                Button("Submit") {
                    updateTradeEntry()
                    dismiss()
                }
                .disabled(trade == nil)
            }
            .padding()

            Divider()

            Form {
                Section {
                    
                    TextField(text: $newTicker,
                              prompt: Text(trade?.ticker.wrappedValue ?? "")) {
                        Text("Edit ticker name")
                    }
                              .textFieldStyle(RoundedBorderTextFieldStyle())
                              .onSubmit { // Activates when user hits enter
                                  focus = .entryField
                              }
                              .focused($focus, equals: .tickerField)
                    
                    
                    TextField(text: $newEntryPrice,
                              prompt: Text(trade?.entry.wrappedValue ?? 0, format: currencyStyle)
                    ) {
                        Text("Edit Entry price")
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        focus = .exitField
                    }
                    .focused($focus, equals: .entryField)
                    
                    
                    TextField(text: $newExitPrice,
                              prompt: Text(nilPrompt(nonNilPrompt: trade?.exit.wrappedValue ?? 0))
                    ) {
                        Text("Edit exit price")
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        focus = .sharesField
                    }
                    .focused($focus, equals: .exitField)
                    
                    
                    TextField(text: $newShares,
                              prompt: Text("\(trade?.shares.wrappedValue ?? 0)")
                    ) {
                        Text("Shares bought")
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        focus = .stopField
                    }
                    .focused($focus, equals: .sharesField)
                    
                    
                    TextField(text: $newStopLoss,
                              prompt: Text(nilPrompt(nonNilPrompt: trade?.stopLoss.wrappedValue ?? 0))) {
                        Text("Edit stop loss")
                    }
                              .textFieldStyle(RoundedBorderTextFieldStyle())
                              .focused($focus, equals: .stopField)
                    
                    DatePicker("New date: ", selection: $newDate, in: ...Date())
                    
                }
            }
        }
        .frame(width: 420, height: 400)
        .onChange(of: editingTradeID) {
            if let trade = trade {
                newDate = trade.date.wrappedValue
            }
        }
    }
    
    // Returns "-" if prompt = 0. It can be confirmed that the arguments sent will not be nil, but instead be 0 because of coalescing the arguments to 0.
    func nilPrompt(nonNilPrompt: Double?) -> String {
        if nonNilPrompt == 0 {
            return "-"
        } else {
            return String(format: "$%.2f", Double(nonNilPrompt ?? 0))
        }
    }
    
    // Necessary for switching from one field to the next after hitting enter
    enum FormFieldFocus: Hashable {
        case tickerField, entryField, exitField, sharesField, stopField
    }
    
    func updateTradeEntry() -> Void {
        
        // Convert text field inputs to proper types
        // Ensure `trade` is non-nil before attempting to update its properties
        if let trade = trade {
            
            if !newTicker.isEmpty {
                trade.ticker.wrappedValue = newTicker
            }

            trade.date.wrappedValue = newDate
            
            if let sharesInt = Int(newShares) {
                trade.shares.wrappedValue = sharesInt
            }
            
            if let entryDouble = Double(newEntryPrice) {
                trade.entry.wrappedValue = entryDouble
            }
            
            if let exitDouble = Double(newExitPrice) {
                trade.exit.wrappedValue = exitDouble
            }
            
            if let stopLossDouble = Double(newStopLoss) {
                trade.stopLoss.wrappedValue = stopLossDouble
            }
        }
        
        // Update the state variables
        newTicker = ""
        newEntryPrice = ""
        newExitPrice = ""
        newShares = ""
        newStopLoss = ""
    }
}

#Preview {
    
    let exampleTrades = TradeEntry.examples()
    EditTradeEntryView(tradeEntries: .constant(exampleTrades), editingTradeID: .constant(exampleTrades[1].id))
}
