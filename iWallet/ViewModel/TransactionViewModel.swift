//
//  TransactionViewModel.swift
//  iWallet
//
//  Created by Vladislav Novoshinskiy on 25.05.2023.
//

import Foundation
import RealmSwift

final class TransactionViewModel: ObservableObject {
    @Published var transactions: [TransactionItem] = []
    
    init() {
        loadData()
    }
    
    // Метод для загрузки транзакций
    func loadData() {
        guard let realm = try? Realm() else {
            print("Ошибка: loadData")
            return
        }
        let transactionsResult = realm.objects(TransactionItem.self)
        transactions = Array(transactionsResult)
    }
    
    // Метод сохранения транзакции
    func saveTransaction(amount: Float, date: Date, note: String, type: CategoryType, category: Category) {
        guard let realm = try? Realm() else {
            print("Ошибка: Не удалось создать экземпляр Realm")
            return
        }
        if let newCategory = realm.object(ofType: Category.self, forPrimaryKey: category.id) {
            let newTransaction = TransactionItem()
            newTransaction.categoryId = newCategory.id
            newTransaction.amount = amount
            newTransaction.date = date
            newTransaction.note = note
            newTransaction.type = type
            do {
                try realm.write {
                    newCategory.transactions.append(newTransaction)
                }
                
                // Обновляю список транзакций после сохранения
                transactions.append(newTransaction)
                
                // Отладочное сообщение
                print("Транзакция сохранена: \(newTransaction)")
            } catch {
                // Отладочное сообщение
                print("Ошибка сохранения транзакции: \(error)")
            }
        } else {
            // Отладочное сообщение, если категория не найдена
            print("Ошибка: категория не найдена")
        }
    }
    
    // Метод для удаления транзакций
    func deleteTransaction(withId id: ObjectId) {
        do {
            let realm = try Realm()
            
            if let transaction = realm.object(ofType: TransactionItem.self, forPrimaryKey: id) {
                try realm.write {
                    if let category = transaction.category.first {
                        if let index = category.transactions.firstIndex(of: transaction) {
                            category.transactions.remove(at: index)
                        }
                    }
                    realm.delete(transaction)
                }
                loadData()
            } else {
                print("Транзакция с ID \(id) не найдена")
            }
        } catch let error {
            print("Ошибка удаления транзакции: \(error)")
        }
    }
    
    // Считает расход
    func totalExpenses() -> Float {
        var expenses: Float = 0
        for transaction in transactions {
            if transaction.type == .expense {
                expenses += transaction.amount
            }
        }
        return expenses
    }
    
    // Считает доход
    func totalIncomes() -> Float {
        var icncome: Float = 0
        for transaction in transactions {
            if transaction.type == .income {
                icncome += transaction.amount
            }
        }
        return icncome
    }
    
    // Считает балланс
    func balance() -> Float {
        return totalIncomes() - totalExpenses()
    }
    
    // Расчет среднего расхода за день, сначала нахожу общее количество дней c транзакциями, а затем разделим общую сумму расходных транзакций на количество дней
    func averageDailyExpense() -> Float {
        let expenseTransactions = transactions.filter { $0.type == .expense }
        guard !expenseTransactions.isEmpty else {
            return 0
        }
        
        let uniqueExpenseDates = Set(expenseTransactions.map { transaction -> Date in
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: transaction.date)
            return calendar.date(from: components) ?? transaction.date
        })
        
        let daysWithTransactions = uniqueExpenseDates.count
        
        let totalExpenseAmount = totalExpenses()
        
        return totalExpenseAmount / Float(daysWithTransactions)
    }
}
