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
    private func deleteTransaction(withId id: ObjectId) {
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
    
    // Метод удаления транзакций
    func deleteTransaction(at offsets: IndexSet, from sortedTransactions: [TransactionItem]) {
        offsets.forEach { index in
            let transaction = sortedTransactions[index]
            deleteTransaction(withId: transaction.id)
        }
    }
    
    // MARK: TransactionView
    // Метод для группировки транзакций по дате
    func transactionsByDate(_ transactions: [TransactionItem]) -> [Date: [TransactionItem]] {
        var groupedTransactions: [Date: [TransactionItem]] = [:]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        for transaction in transactions {
            let dateString = dateFormatter.string(from: transaction.date)
            if let date = dateFormatter.date(from: dateString) {
                if groupedTransactions[date] == nil {
                    groupedTransactions[date] = []
                }
                groupedTransactions[date]?.append(transaction)
            }
        }
        
        return groupedTransactions
    }
    
    // Метод фильтрации категорий
    func filterCategories(categories: [Category], transaction: TransactionItem) -> Category? {
        for category in categories {
            if category.id == transaction.categoryId {
                return category
            }
        }
        return nil
    }
    
    // метод сортировки транзакций по дате
    func sortTransactionsByDate(transactions: [TransactionItem]) -> [TransactionItem] {
        return transactions.sorted(by: { $0.date > $1.date })
    }
    
    // MARK: TransactionCategoryView
    // метод фильтрации транзакции с выбранной категорией
    func filterTransaction(category: Category, transactions: [TransactionItem]) -> [TransactionItem] {
        var groupedTransaction: [TransactionItem] = []
        
        for transaction in transactions {
            if category.id == transaction.categoryId {
                groupedTransaction.append(transaction)
            }
        }
        return groupedTransaction
    }
    
    // MARK: AddTransactionView
    // метод фильтрации транзакций для отбора уникальных заметок
    func filterTransactionsNote(category: Category, transactions: [TransactionItem]) -> [TransactionItem] {
        var groupedTransaction: [TransactionItem] = []
        var uniqueNotes: [String] = []
        
        for transaction in transactions {
            if category.id == transaction.categoryId {
                if transaction.note.count != 0 {
                    if !uniqueNotes.contains(transaction.note.description) {
                        uniqueNotes.append(transaction.note.description)
                        groupedTransaction.append(transaction)
                    }
                }
            }
        }
        return groupedTransaction
    }
    
    // MARK: HomeView
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
