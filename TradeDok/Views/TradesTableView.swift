//
//  TradesTableView.swift
//  TradeDok
//
//  Created by Reese Oo on 12/22/24.
//

import SwiftUI
import Foundation

struct TradesTableView: View {
    
    @Binding var tradeEntries: [TradeEntry] // Source of truth is in ContentView
    @State private var selection: Set<TradeEntry.ID> = []  // Requires ID in all caps.
    
    @Binding var editingTradeID: TradeEntry.ID?  // Needed for finding and editing a trade a user selects. Passes to EditTradeEntryView
    
    // Sets the numbers to format to $ USD. ChatGPT told me how to make this
    let currencyStyle = FloatingPointFormatStyle<Double>.Currency(code: "USD")
    
    var body: some View {
        
        // Table with a binding to tradeEntries
        Table(tradeEntries, selection: $selection) {
            TableColumn("Date") { trade in
                Text(trade.date, style: .date)
            }
            TableColumn("Ticker", value: \.ticker)
            TableColumn("Entry") { trade in
                Text(trade.entry, format: currencyStyle)
            }
            TableColumn("Exit") { trade in
                // Check if exit has been input already
                if trade.exit != nil {
                    Text(trade.exit ?? 0, format: currencyStyle)
                }
                else {
                    Text("-")
                }
            }
            TableColumn("Shares") { trade in
                Text("\(trade.shares)")
            }
            TableColumn("Stop loss") { trade in
                if trade.stopLoss != nil {
                    Text(trade.stopLoss ?? 0, format: currencyStyle)
                }
                else {  // No stop loss given
                    Text("-")
                }
            }
            /* // Open risk, decided not to include this column because there seems to be a limit of 10 columns per table
             TableColumn("Open risk") { trade in
             if trade.openRisk != nil {
             Text(trade.openRisk ?? 0, format: currencyStyle)
             }
             else {  // No open risk calculated and no stop loss given or exit price given
             Text("-")
             }
             }
             */
            TableColumn("Entry total") { trade in
                Text(trade.entry * Double(trade.shares), format: currencyStyle)
            }
            TableColumn("Exit total") { trade in
                if trade.exit != nil {
                    Text((trade.exit ?? 0) * Double(trade.shares), format: currencyStyle)
                }
                else {
                    Text("-")
                }
            }
            TableColumn("Return") { trade in
                if trade.exit != nil {
                    if (trade.exit ?? 0 > trade.entry) {
                        Text(trade.totalReturn ?? 0, format: currencyStyle)
                            .foregroundStyle(.green)
                    }
                    else if (trade.exit ?? 0 < trade.entry) {
                        Text(trade.totalReturn ?? 0, format: currencyStyle)
                            .foregroundStyle(.red)
                    }
                    else {  // Break even, no gain or loss
                        Text(trade.totalReturn ?? 0, format: currencyStyle)
                            .foregroundStyle(.gray)
                    }
                }
                else {  // Exit not given
                    Text("-")
                }
            }
            TableColumn("% Return") { trade in
                if let exit = trade.exit {
                    let percentGain = (exit - trade.entry) / trade.entry * 100
                    if percentGain > 0 {
                        Text(String(format: "%.2f%%", percentGain))
                            .foregroundStyle(.green)
                    } else if percentGain < 0 {
                        Text(String(format: "%.2f%%", percentGain))
                            .foregroundStyle(.red)
                    } else {  // Break even, no gain or loss
                        Text(String(format: "%.2f%%", percentGain))
                            .foregroundStyle(.gray)
                    }
                } else {  // Exit not given
                    Text("-")
                }
            }
            
        }
        .contextMenu {
            Button(role: .destructive) {
                tradeEntries.removeAll { trade in
                    selection.contains(trade.id)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
            Button {
                // ChatGPT wrote this button action
                if let selectedID = selection.first,
                   let index = tradeEntries.firstIndex(where: { $0.id == selectedID }) {
                    editingTradeID = tradeEntries[index].id
                }
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .disabled(selection.count != 1)
            
        }
    }
}

#Preview {
    let exampleTrades = TradeEntry.examples()
    TradesTableView(tradeEntries: .constant(exampleTrades), editingTradeID: .constant(exampleTrades[1].id))
        .frame(width: 500, height: 800)
}


