//
//  RealmViewModel.swift
//  iWallet
//
//  Created by Vladislav Novoshinskiy on 24.05.2023.
//

import Foundation
import RealmSwift

final class AppViewModel: ObservableObject {
    
    init() {
        let config = Realm.Configuration(schemaVersion: 15)
        Realm.Configuration.defaultConfiguration = config
    }
    
}





