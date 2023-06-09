//
//  RealmViewModel.swift
//  iWallet
//
//  Created by Vladislav Novoshinskiy on 24.05.2023.
//

import Foundation
import RealmSwift
import SwiftUI

final class AppViewModel: ObservableObject {
    
    @AppStorage("playFeedbackHaptic") var selectedFeedbackHaptic: Bool = true
    @AppStorage("hasRunBefore") var hasRunBefore: Bool = false
    @AppStorage("currencySymbol") var currencySymbol: String = "USD"
    @AppStorage("roundingNumbers") var roundingNumbers: Bool = false
    
    init() {
        let config = Realm.Configuration(schemaVersion: 15)
        Realm.Configuration.defaultConfiguration = config
    }
}
