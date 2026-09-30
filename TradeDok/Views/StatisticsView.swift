//
//  StatisticsView.swift
//  TradeDok
//
//  Created by Reese Oo on 12/21/24.
//

import SwiftUI


struct StatisticsView: View {
    @Binding var tradeEntries: [TradeEntry]
    
    let currencyStyle = FloatingPointFormatStyle<Double>.Currency(code: "USD")
    
    var stats: Statistics {
        Statistics(tradeEntries: tradeEntries)
    }
    
    var body: some View {
        VStack {
            Text("Your statistics")
                .font(.largeTitle)
                .padding()
            Group {
                Text("Total Trades: \(stats.totalTrades)")
                Text("Total Open Trades: \(stats.openTrades)")
                Text("Total Wins: \(stats.totalWins)")
                Text("Total Losses: \(stats.totalLosses)")
                Text("Total Washes (breakeven trades): \(stats.totalWashes)")
                Text("Average win: \(stats.averageGain, format: currencyStyle)")
                Text("Average loss: \(stats.averageLoss, format: currencyStyle)")
                Text("Win Rate: \(String(format: "%.2f%%", stats.winRate))")
                Text("Loss Rate: \(String(format: "%.2f%%", stats.lossRate))")
                Text("PnL: \(stats.ProfitAndLoss, format: currencyStyle)")
                Text("Account risk: \(stats.accountRisk, format: currencyStyle)")
            }
            
        }
    }
    
}

#Preview {
    StatisticsView(tradeEntries: .constant([]))
        .frame(width: 500, height: 500)
}
