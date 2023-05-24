//
//  ExtensionFloat.swift
//  iWallet
//
//  Created by Vladislav Novoshinskiy on 24.05.2023.
//

import Foundation

// метод возвращает сумму с точками после каждых трех символов
extension Float {
    func formattedWithSeparatorAndCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSize = 3
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = 0
        
        let formattedNumber = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return formattedNumber
    }
}
