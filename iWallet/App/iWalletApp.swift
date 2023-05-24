//
//  iWalletApp.swift
//  iWallet
//
//  Created by Владислав Новошинский on 28.03.2023.
//

import SwiftUI

@main
struct iWalletApp: App {
    @ObservedObject var viewModel = SceneViewModel()
    @AppStorage("hasRunBefore") private var hasRunBefore = false
    @AppStorage("playFeedbackHaptic") private var selectedFeedbackHaptic: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if !hasRunBefore {
                withAnimation {
                    WelcomeView()
                        .environmentObject(viewModel)
                }
            } else {
                withAnimation {
                    HomeView()
                        .environmentObject(viewModel)
                }
            }
        }
    }
}



