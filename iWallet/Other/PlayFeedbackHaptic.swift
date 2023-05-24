//
//  PlayFeedbackHaptic.swift
//  iWallet
//
//  Created by Vladislav Novoshinskiy on 24.05.2023.
//

import SwiftUI

public func playFeedbackHaptic(_ selected: Bool) {
    if selected == true {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
