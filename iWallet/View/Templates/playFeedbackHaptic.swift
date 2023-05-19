//
//  playFeedbackHaptic.swift
//  iWallet
//
//  Created by Владислав Новошинский on 15.04.2023.
//

import SwiftUI

public func playFeedbackHaptic(_ selected: Bool) {
    if selected == true {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
