//
//  Statistics.swift
//  TradeDok
//
//  Created by Reese Oo on 12/21/24.
//

import SwiftData
import SwiftUI

struct Statistics {
    
    // Initialize all variables to 0 to perform calculations later on
    var winRate: Double = 0
    var lossRate: Double = 0
    var averageGain: Double = 0
    var averageLoss: Double = 0
    var accountRisk: Double = 0
    var totalWins: Int = 0
    var totalLosses: Int = 0
    var totalWashes: Int = 0
    var totalTrades: Int = 0
    var openTrades: Int = 0
    var ProfitAndLoss: Double = 0   // Refers to all the money made or lost calculated into one number
    
    init(tradeEntries: [TradeEntry]) {  // Recieves a tradeEntries variable of type TradeEntry, then assigns all variables new dara
        
        // All calculations that need each trades' data is in the following for loop
        for trade in tradeEntries {
            if let exit = trade.exit {
                
                // Determine wins and losses
                if (trade.isGain ?? false) {
                    totalWins += 1
                }
                else if (trade.isLoss ?? false) {
                    totalLosses += 1
                }
                else {
                    totalWashes += 1
                }
                // Update profit/loss. line written by ChatGPT
                ProfitAndLoss += (exit - trade.entry) * Double(trade.shares)
            }
            totalTrades += 1
        }
        
        // Update number of open trades
        openTrades = totalTrades - (totalWins + totalLosses + totalWashes)
        
        
        if (totalTrades != 0) {     // Only calculate wins and gains if there are trades
            if (totalWins != 0) {   // Calculates average winRate and averageGain
                winRate = Double(totalWins) / Double(totalTrades) * 100 // ChatGPT rewrote this line
                averageGain = tradeEntries
                    .filter { $0.isGain == true }
                    .reduce(0) { $0 + ($1.totalReturn ?? 0) }  // Accumulates all gains from winning trades into one number. $0 represents accumulated number while $1 represents the next gain in the array
                averageGain /= Double(totalWins)
            }
            if (totalLosses != 0) {  // Calculates average lossRate and averageLoss
                lossRate = Double(totalLosses) / Double(totalTrades) * 100
                averageLoss = tradeEntries
                    .filter { $0.isLoss == true }
                    .reduce(0) { $0 + ($1.totalReturn ?? 0) }
                averageLoss /= Double(totalLosses)
            }
            accountRisk = tradeEntries
                .filter { $0.openRisk != nil}
                .reduce(0) { $0 + ($1.openRisk ?? 0) }
        }
    }
}
