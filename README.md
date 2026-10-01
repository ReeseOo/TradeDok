# TradeDok DEMO

TradeDok is a demo MacOS trade journaling app that allows users to add, edit, and view trade entries. With trade entries, statistics such as win rate, account risk, average wins, and others are displayed as statistics.  TradeDok was made using the SwiftUI and the Swift programming language. 

<img width="1512" height="406" alt="Screenshot 2026-09-30 at 10 49 08 PM" src="https://github.com/user-attachments/assets/1bea18eb-3b83-4b49-aff2-6ca3ffd20225" />

<img width="432" height="336" alt="Screenshot 2026-09-30 at 10 49 26 PM" src="https://github.com/user-attachments/assets/06e40bc6-f7ff-4609-abfe-e492f9c44859" />

<img width="509" height="435" alt="Screenshot 2026-09-30 at 10 49 44 PM" src="https://github.com/user-attachments/assets/82301166-1519-4427-8820-5c98f14c257a" />


There are two main folders upon which I coded my files.

First, there is the Model folder, which does the backend data processing (such as trade data and statistics calculations) that is displayed in views. It contains the files Statistics.swift and TradeEntry.swift

Secondly, there's the Views folder. This displays views using SwiftUI. It contains ContentView.swift, EditTradeEntryView.swift, StatisticsView.swift, TradeEntryView.swift, and TradesTableView.swift.

This demo app was first built two years ago and was intended to support native MacOS use. 

Roadmap:
There are multiple features I will continue to add to make this fully fleshed out:
- **Most important of all features, persistence must be implemented via SwiftData**
- The UI should have a modern appearance that uses SwiftUI capabilities to the fullest
- Additional statistics should be displayed and allow programmable statistics from user input
- Graphs and API integration for live stocks data
- Support for iOS should be implemented
