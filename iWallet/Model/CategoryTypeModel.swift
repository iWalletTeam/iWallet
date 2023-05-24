//
//  CategoryType.swift
//  iWallet
//
//  Created by Vladislav Novoshinskiy on 24.05.2023.
//

import Foundation
import RealmSwift

enum CategoryType: String, PersistableEnum, CaseIterable {
    case expense = "Expense"
    case income = "Income"
    
    func localizedName() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
