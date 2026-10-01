//
//  TradeEntry.swift
//  TradeDok
//
//  Created by Reese Oo on 12/21/24.
//


import SwiftData
import Foundation

struct TradeEntry: Identifiable {
    var id = UUID() // Automatically generate a unique ID
    var ticker: String
    var shares: Int
    var entry: Double
    var exit: Double?
    var stopLoss: Double?
    var date: Date
    var openRisk: Double? {
        if exit == nil && stopLoss != nil {
            return (entry - (stopLoss ?? 0)) * Double(shares)
        }
        else {
            return nil
        }
    }
    var totalReturn: Double? { // Total return of the trade
        if exit != nil {
            return ((exit ?? 0) - entry) * Double(shares) // Force unwrap exit because it can only not be nil as a condition anyway
        }
        else {
            return nil
        }
    }
    var isGain: Bool? { 
        guard let exitPrice = exit else { return false } // If no exit price, return false
        return exitPrice > entry
    }
    var isLoss: Bool? {
        guard let exitPrice = exit else { return false } // If no exit price, return false
        return exitPrice < entry
    }
    
    
    init(id: UUID = UUID(), ticker: String, shares: Int, entry: Double, exit: Double? = nil, stopLoss: Double? = nil, date: Date, isGain: Bool? = nil, isLoss: Bool? = nil) {
        self.id = id
        self.ticker = ticker
        self.shares = shares
        self.entry = entry
        self.exit = exit
        self.stopLoss = stopLoss
        self.date = date
        // self.isGain = isGain
        // self.isLoss = isLoss
    }
    
    
    static func example() -> TradeEntry {
        return TradeEntry(ticker: "GME", shares: 120, entry: 63.50, date: Date())
    }
    
    // Example array of TradeEntry to append to TradeEntries struct
    // ChatGPT wrote the examples for me
    static func examples() -> [TradeEntry] {
        return [ TradeEntry(ticker: "NVDA", shares: 50, entry: 12.50, date: Date()),
                 TradeEntry(ticker: "AAPL", shares: 10, entry: 150.0, exit: 175.00, stopLoss: nil, date: Date()),
                 TradeEntry(ticker: "TSLA", shares: 5, entry: 700.0, exit: 400, stopLoss: nil, date: Date()),
                 TradeEntry(ticker: "GOOG", shares: 15, entry: 2800.0, exit: 2900.0, stopLoss: 2750.0, date: Date().addingTimeInterval(-86400 * 30)), // Profit
                 TradeEntry(ticker: "AMZN", shares: 20, entry: 3200.0, exit: 3100.0, stopLoss: 3000.0, date: Date().addingTimeInterval(-86400 * 45)), // Loss
                 TradeEntry(ticker: "MSFT", shares: 30, entry: 290.0, exit: nil, stopLoss: 270.0, date: Date()), // Still in progress
                 TradeEntry(ticker: "META", shares: 40, entry: 150.0, exit: 165.0, stopLoss: 140.0, date: Date().addingTimeInterval(-86400 * 10)), // Profit
                 TradeEntry(ticker: "NFLX", shares: 25, entry: 500.0, exit: 495.0, stopLoss: nil, date: Date().addingTimeInterval(-86400 * 20)), // Small loss
                 TradeEntry(ticker: "INTC", shares: 100, entry: 50.0, exit: nil, stopLoss: 45.0, date: Date().addingTimeInterval(-86400 * 5)), // Still in progress
                 TradeEntry(ticker: "AMD", shares: 60, entry: 90.0, exit: 110.0, stopLoss: 85.0, date: Date().addingTimeInterval(-86400 * 15)) // Profit
                 
        ]
    }
}


/*
 guard does something but need to check Swift docs I forgot
 
 */
