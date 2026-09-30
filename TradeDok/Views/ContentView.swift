//
//  ContentView.swift
//  TradeDok
//
//  Created by Reese Oo on 12/22/24.
//

import SwiftUI


struct ContentView: View {
    @State private var selectedTab = 1
    @State private var tradeEntries: [TradeEntry] = TradeEntry.examples() // Source of truth and array holds all the trade entries. For now set to examples
    
    @State private var editingTradeID: TradeEntry.ID? = nil
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TradeEntryView(tradeEntries: $tradeEntries).tabItem { Text("Enter trades") }.tag(1)
            TradesTableView(tradeEntries: $tradeEntries, editingTradeID: $editingTradeID).tabItem { Text("Your trades") }.tag(2)
            EditTradeEntryView(tradeEntries: $tradeEntries, editingTradeID: $editingTradeID).tabItem { Text("Edit trades") }.tag(3)
            StatisticsView(tradeEntries: $tradeEntries).tabItem { Text("Your stats") }.tag(4)
            }
        }
    }

#Preview {
    ContentView()
        .frame(width: 800, height: 800)
}
