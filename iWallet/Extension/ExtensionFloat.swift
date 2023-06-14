//
//  ExtensionFloat.swift
//  iWallet
//
//  Created by Vladislav Novoshinskiy on 24.05.2023.
//

import Foundation

// метод возвращает сумму с точками после каждых трех символов
extension Float {
    func formattedWithSeparatorAndCurrency(roundingNumbers: Bool) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if roundingNumbers == true {
            formatter.maximumFractionDigits = 0
        } else {
            formatter.maximumFractionDigits = 2
        }
        let formattedNumber = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return formattedNumber
    }
}
