//  TransactionCategoryView.swift

import SwiftUI
import RealmSwift

struct TransactionCategoryView: View {
    @EnvironmentObject var viewModel: SceneViewModel
    @ObservedResults(TransactionItem.self) var transactions
    
    @Binding var selectedCategory: Category
    @AppStorage("currencySymbol") private var currencySymbol: String = "USD"
    @AppStorage("playFeedbackHaptic") private var selectedFeedbackHaptic: Bool = true
    
    var filteredTransactions: [TransactionItem] {
        filterTransaction(category: selectedCategory, transactions: Array(transactions))
    }
    
    var body: some View {
        List {
            if transactions.isEmpty {
                previewCard()
            } else {
                let groupedTransactions = transactionsByDate(Array(filteredTransactions))
                ForEach(groupedTransactions.keys.sorted(by: { $0 > $1 }), id: \.self) { date in
                    Section(header: Text(date, style: .date).bold()) {
                        let sortedTransactions = sortTransactionsByDate(transactions: groupedTransactions[date]!)
                        
                        ForEach(sortedTransactions, id: \.self) { transaction in
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    HStack {
                                        Divider()
                                            .foregroundColor(Color(selectedCategory.color))
                                            .frame(width: 5, height: 72)
                                            .background(Color(selectedCategory.color))
                                    } .padding(.trailing, 3)
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            if transaction.type == CategoryType.expense {
                                                Text("-\(transaction.amount.formattedWithSeparatorAndCurrency()) \(currencySymbol)")
                                                    .font(.title3).bold()
                                            } else {
                                                Text("\(transaction.amount.formattedWithSeparatorAndCurrency()) \(currencySymbol)")
                                                    .font(.title3).bold()
                                            }
                                            Spacer()
                                            HStack {
                                                Text(selectedCategory.name)
                                                    .foregroundColor(Color("colorBalanceText")).textCase(.uppercase)
                                                    .font(.caption)
                                                    .multilineTextAlignment(.trailing)
                                                    .dynamicTypeSize(.small)
                                                    .padding(0)
                                                Image(systemName: selectedCategory.icon)
                                                    .font(.caption).dynamicTypeSize(.small)
                                                    .foregroundColor(.black)
                                                    .frame(width: 20, height: 20)
                                                    .background(Color(selectedCategory.color))
                                                    .cornerRadius(5)
                                                    .padding(0)
                                            } .padding(0)
                                        }
                                        HStack {
                                            Text(transaction.note)
                                                .foregroundColor(Color(.gray)).textCase(.uppercase)
                                                .font(.subheadline).dynamicTypeSize(.small)
                                            Spacer()
                                            Text(selectedCategory.type.localizedName())
                                                .foregroundColor(Color(.gray)).textCase(.uppercase)
                                                .font(.subheadline).dynamicTypeSize(.small)
                                        }
                                    }    .padding(.leading, 10)
                                }
                            }
                            .padding(.vertical, 5)
                            .frame(height: 50)
                        }
                        .onDelete(perform: { indexSet in
                            deleteTransaction(at: indexSet, from: sortedTransactions)
                            playFeedbackHaptic(selectedFeedbackHaptic)
                        })
                    }
                }
            }
        }
        .background(Color("colorBG"))
        .scrollContentBackground(.hidden)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if transactions.isEmpty {
                    EditButton().disabled(true)
                } else {
                    EditButton()
                }
            }
        }
    }
    
    // метод фильтрации транзакции с выбранной категорией
    private func filterTransaction(category: Category, transactions: [TransactionItem]) -> [TransactionItem] {
        var groupedTransaction: [TransactionItem] = []
        
        for transaction in transactions {
            if category.id == transaction.categoryId {
                groupedTransaction.append(transaction)
            }
        }
        return groupedTransaction
    }
    
    // Метод для группировки транзакций по дате
    private func transactionsByDate(_ transactions: [TransactionItem]) -> [Date: [TransactionItem]] {
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
    
    // метод сортировки транзакций по дате
    private func sortTransactionsByDate(transactions: [TransactionItem]) -> [TransactionItem] {
        return transactions.sorted(by: { $0.date > $1.date })
    }
    
    // Метод удаления транзакций
    private func deleteTransaction(at offsets: IndexSet, from sortedTransactions: [TransactionItem]) {
        withAnimation {
            offsets.forEach { index in
                let transaction = sortedTransactions[index]
                viewModel.deleteTransaction(withId: transaction.id)
            }
        }
    }
}

struct TransactionCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleCategory = Category(value: ["name": "Транспорт", "icon": "bus.fill", "color": "colorGray1", "type": CategoryType.expense] as [String : Any])
        
        TransactionCategoryView(selectedCategory: Binding(get: { exampleCategory }, set: { _ in }))
    }
}
