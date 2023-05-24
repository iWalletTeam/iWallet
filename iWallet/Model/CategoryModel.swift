//
//  CategoryModel.swift
//  iWallet
//
//  Created by Vladislav Novoshinskiy on 24.05.2023.
//

import Foundation
import RealmSwift

class Category: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId = ObjectId.generate()
    @Persisted var name: String = ""
    @Persisted var icon: String = ""
    @Persisted var color: String = ""
    @Persisted var type: CategoryType = .expense
    @Persisted var transactions: List<Transaction> = List<Transaction>()
    
    // Функция проверяет, есть ли в категории транзакции с выбранным типом (доход или расход)
    func hasTransactions(type: CategoryType) -> Bool {
        for transaction in transactions {
            if transaction.type == type {
                return true
            }
        }
        return false
    }
    
    // Функция которая вычисляет сумму всех транзакций определенного типа (категории) из списка транзакций.
    func categoryAmount(type: CategoryType) -> Float {
        var totalAmount: Float = 0
        for transaction in transactions {
            if transaction.type == type {
                totalAmount += transaction.amount
            }
        }
        return totalAmount
    }
}
