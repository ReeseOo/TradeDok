//
//  ContentView.swift
//  TradeDok
//
//  Created by Reese Oo on 12/22/24.
//

import SwiftUI


struct ContentView: View {
    @State private var tradeEntries: [TradeEntry] = TradeEntry.examples()
    @State private var editingTradeID: TradeEntry.ID? = nil
    @State private var showingEntrySheet = false
    @State private var showingEditSheet = false
    @State private var selectedSection: AppSection? = .trades

    // The two sections in the sidebar
    enum AppSection: String, CaseIterable, Identifiable {
        case trades = "Trades"
        case statistics = "Statistics"
        var id: Self { self }
    }

    var body: some View {
        NavigationSplitView {
            // Left sidebar
            List(AppSection.allCases, selection: $selectedSection) { section in
                switch section {
                case .trades:
                    Label("Trades", systemImage: "list.bullet")
                case .statistics:
                    Label("Statistics", systemImage: "chart.bar")
                }
            }
            .navigationTitle("TradeDok")
        } detail: {
            // Right panel — changes based on sidebar selection
            switch selectedSection {
            case .trades:
                TradesTableView(tradeEntries: $tradeEntries, editingTradeID: $editingTradeID)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                showingEntrySheet = true
                            } label: {
                                Label("Add Trade", systemImage: "plus")
                            }
                        }
                    }
            case .statistics:
                StatisticsView(tradeEntries: $tradeEntries)
            case nil:
                Text("Select a section from the sidebar.")
                    .foregroundStyle(.secondary)
            }
        }
        // Entry form sheet — opens when + button is tapped
        .sheet(isPresented: $showingEntrySheet) {
            TradeEntryView(tradeEntries: $tradeEntries)
        }
        // Edit form sheet — opens automatically when a trade is selected for editing
        .sheet(isPresented: $showingEditSheet) {
            EditTradeEntryView(tradeEntries: $tradeEntries, editingTradeID: $editingTradeID)
        }
        // When editingTradeID is set (user clicked Edit in context menu), open the edit sheet
        .onChange(of: editingTradeID) {
            if editingTradeID != nil {
                showingEditSheet = true
            }
        }
        // When edit sheet closes, clear the selected trade ID
        .onChange(of: showingEditSheet) {
            if !showingEditSheet {
                editingTradeID = nil
            }
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 900, height: 600)
}
