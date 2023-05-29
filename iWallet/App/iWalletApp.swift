//
//  iWalletApp.swift
//  iWallet
//
//  Created by Владислав Новошинский on 28.03.2023.
//

import SwiftUI

@main
struct iWalletApp: App {
    @ObservedObject var appVM = AppViewModel()
    @ObservedObject var categoryVM = CategoryViewModel()
    @ObservedObject var transactionVM = TransactionViewModel()
    
    @AppStorage("hasRunBefore") private var hasRunBefore = false
    @AppStorage("currencySymbol") private var currencySymbol: String = "USD"
    @AppStorage("playFeedbackHaptic") private var selectedFeedbackHaptic: Bool = true
        
    var body: some Scene {
        WindowGroup {
            if !hasRunBefore {
                withAnimation {
                    WelcomeView()
                        .environmentObject(appVM)
                        .environmentObject(categoryVM)
                        .environmentObject(transactionVM)
                }
            } else {
                withAnimation {
                    HomeView()
                        .environmentObject(appVM)
                        .environmentObject(categoryVM)
                        .environmentObject(transactionVM)
                }
            }
        }
    }
}



