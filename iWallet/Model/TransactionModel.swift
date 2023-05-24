//
//  TransactionModel.swift
//  iWallet
//
//  Created by Vladislav Novoshinskiy on 24.05.2023.
//

import Foundation
import RealmSwift

class TransactionItem: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId = ObjectId.generate()
    @Persisted var categoryId: ObjectId = ObjectId.generate()
    @Persisted var amount: Float = 0
    @Persisted var note: String = ""
    @Persisted var date: Date = Date()
    @Persisted var type: CategoryType = .expense
    @Persisted(originProperty: "transactions") var category: LinkingObjects<Category>
}

