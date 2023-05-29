//
//  CategoryViewModel.swift
//  iWallet
//
//  Created by Vladislav Novoshinskiy on 24.05.2023.
//

import Foundation
import RealmSwift

final class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] = []
    
    init() {
        loadData()
    }
    
    // Метод для загрузки категорий
    func loadData() {
        guard let realm = try? Realm() else {
            print("Ошибка: loadData")
            return
        }
        let categoriesResult = realm.objects(Category.self)
        categories = Array(categoriesResult)
    }
    
    // Добавления категорий по умолчанию
    func createDefaultCategories() {
        guard let realm = try? Realm() else {
            print("Ошибка: Не удалось создать категории по умолчанию Realm")
            return
        }
        
        let defaultCategory = defaultCategoriesModel
        
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
            
            // отладочное сообщение
            return print("Категория сохранена: \(newCategory)")
        } catch {
            // отладочное сообщение
            return print("Ошибка сохранения категории: \(error)")
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
}
