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
    
    var body: some Scene {
        
        // переменная для поиска пути локального хранения базы данных
        // let _ = print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
        
        WindowGroup {
            if !appVM.hasRunBefore {
                WelcomeView()
                    .environmentObject(appVM)
                    .environmentObject(categoryVM)
                    .environmentObject(transactionVM)
                
            } else {
                HomeView()
                    .environmentObject(appVM)
                    .environmentObject(categoryVM)
                    .environmentObject(transactionVM)
            }
        }
    }
}



