//  ViewModel.swift

import Foundation
import RealmSwift

final class SceneViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var transactions: [TransactionItem] = []
    
    init() {
        let config = Realm.Configuration(schemaVersion: 15)
        Realm.Configuration.defaultConfiguration = config
        loadData()
    }
    
    func clearDatabase() {
        guard let realm = try? Realm() else {
            print("Ошибка: clearDatabase")
            return
        }
        
        do {
            try realm.write {
                realm.deleteAll()
                loadData()
            }
        } catch {
            print("Ошибка при удалении данных: \(error.localizedDescription)")
        }
    }
    
    // Метод для загрузки базы
    private func loadData() {
        guard let realm = try? Realm() else {
            print("Ошибка: loadData")
            return
        }
        
        let categoriesResult = realm.objects(Category.self)
        let transactionsResult = realm.objects(TransactionItem.self)
        
        categories = Array(categoriesResult)
        transactions = Array(transactionsResult)
    }
}

extension SceneViewModel {
    
    // Добавления категорий по умолчанию
    func createDefaultCategories() {
        guard let realm = try? Realm() else {
            print("Ошибка: Не удалось создать категории по умолчанию Realm")
            return
        }
        
        let defaultCategory = defaultCategories
        
        try! realm.write {
            for category in defaultCategory {
                realm.add(category)
            }
        }
    }
    
    // Метод сохранения категории
    func saveCategory(name: String, icon: String, color: String, type: CategoryType) {
        guard let realm = try? Realm() else {
            print("Ошибка: Не удалось создать экземпляр Realm")
            return
        }
        let newCategory = Category()
        newCategory.name = name
        newCategory.icon = icon
        newCategory.color = color
        newCategory.type = type
        do {
            try realm.write {
                realm.add(newCategory)
            }
            return print("Категория сохранена: \(newCategory)") // отладочное сообщение
        } catch {
            return print("Ошибка сохранения категории: \(error)") // отладочное сообщение
        }
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
                transactions.append(newTransaction) // Обновите список транзакций после сохранения
                print("Транзакция сохранена: \(newTransaction)") // Отладочное сообщение
            } catch {
                print("Ошибка сохранения транзакции: \(error)")
            }
        } else {
            print("Ошибка: категория не найдена") // Отладочное сообщение, если категория не найдена
        }
    }
    
    // Метод для удаления категории
    func deleteCategory(id: ObjectId) {
        do {
            let realm = try Realm()
            if let category = realm.object(ofType: Category.self, forPrimaryKey: id) {
                try realm.write {
                    // Удаление всех транзакций, связанных с категорией
                    for transaction in category.transactions {
                        realm.delete(transaction)
                    }
                    
                    // Удаление категории
                    realm.delete(category)
                }
                loadData()
            }
        } catch {
            print("Error deleting category: \(error)")
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
    
    // Не нужная функция оставил вдруг понадобиться
    // Расчет средней суммы за день, сначала найдем общее количество дней между самой ранней и самой поздней транзакцией, а затем разделим общую сумму транзакций на количество дней
    func averageDailyAmount() -> Float {
        guard let earliestTransaction = transactions.min(by: { $0.date < $1.date }),
              let latestTransaction = transactions.max(by: { $0.date < $1.date }) else {
            return 0
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: earliestTransaction.date, to: latestTransaction.date)
        guard let days = components.day, days > 0 else {
            return 0
        }
        
        let totalAmount = transactions.reduce(0) { (result, transaction) -> Float in
            return result + transaction.amount
        }
        
        return totalAmount / Float(days)
    }
    
    // Расчет среднего расхода за день, сначала найдем общее количество дней c транзакциями, а затем разделим общую сумму расходных транзакций на количество дней
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


