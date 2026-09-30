//
//  TradeEntryView.swift
//  TradeDok
//
//  Created by Reese Oo on 12/21/24.
//

import SwiftUI

struct TradeEntryView: View {
    
    // State variables store the information input into the textfields
    @State private var ticker: String = ""
    @State private var entryPrice: String = ""
    @State private var exitPrice: String = ""
    @State private var shares: String = ""
    @State private var stopLoss: String = ""
    @State private var date = Date()
    @Binding var tradeEntries: [TradeEntry] // Binding to source of truth in content view
    
    @FocusState private var focus: FormFieldFocus?  // Needed for changing text field focus. Constantly changing enum case based on what text field user hits enter in
    
    var body: some View {
        VStack() {
            Form {
                Section {
                    TextField(text: $ticker, prompt: Text("Required")) {
                        Text("Ticker name")
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit { // Activates when user hits enter
                        focus = .entryField
                    }
                    .focused($focus, equals: .tickerField)
                    
                    
                    TextField(text: $entryPrice, prompt: Text("Required")) {
                        Text("Entry price")
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        focus = .exitField
                    }
                    .focused($focus, equals: .entryField)
                    
                    
                    TextField(text: $exitPrice, prompt: Text("Optional")) {
                        Text("Exit price")
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        focus = .sharesField
                    }
                    .focused($focus, equals: .exitField)
                    
                    
                    TextField(text: $shares, prompt: Text("Required")) {
                        Text("Shares bought")
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        focus = .stopField
                    }
                    .focused($focus, equals: .sharesField)
                    
                    
                    TextField(text: $stopLoss, prompt: Text("Optional")) {
                        Text("Stop loss")
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focus, equals: .stopField)
                    
                    DatePicker("Date: ", selection: $date, in: ...Date())
                    
                    
                } header: {
                    HStack {
                        Text("Enter your trade information")
                            .italic()
                            .bold()
                            .font(.largeTitle)
                            .padding(-80)
                    }
                }
                .padding(10)
                
                
                // Variable that checks for if the fields are filled
                var isFormValid: Bool {
                    !ticker.isEmpty &&
                    Double(entryPrice) != nil &&
                    Int(shares) != nil
                }
                
                Button("Submit entry") {
                    // Button action goes here
                    addTradeEntry()
                }
                .disabled(!isFormValid) // Button won't work until form filled out
            }
        }
        .onAppear() {
            focus = .tickerField
        }
        .frame(width: 500)
    }
    
    // Necessary for switching from one field to the next after hitting enter
    enum FormFieldFocus: Hashable {
        case tickerField, entryField, exitField, sharesField, stopField
    }
    
    // addTradeEntry Written by ChatGPT **
    func addTradeEntry() -> Void {
        // Convert text field inputs to proper types
        guard let sharesInt = Int(shares),
              let entryDouble = Double(entryPrice) else {
            print("Invalid input")
            return
        }
        
        let exitDouble = Double(exitPrice) // Optional value
        let stopLossDouble = Double(stopLoss) // Optional value
        
        // Create a new TradeEntry instance
        let newEntry = TradeEntry(
            ticker: ticker,
            shares: sharesInt,
            entry: entryDouble,
            exit: exitDouble,
            stopLoss: stopLossDouble,
            date: date
        )
        
        // Append the new entry to the tradeEntries array
        tradeEntries.append(newEntry)
        
        // Clear the text fields
        ticker = ""
        entryPrice = ""
        exitPrice = ""
        shares = ""
        stopLoss = ""
    }
}



#Preview {
    TradeEntryView(tradeEntries: .constant([]))
        .frame(width: 500, height: 500)
}

