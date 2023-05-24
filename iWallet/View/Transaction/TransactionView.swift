//  TransactionView.swift

import SwiftUI
import RealmSwift

struct TransactionView: View {
    @EnvironmentObject var viewModel: SceneViewModel
    @Environment(\.dismiss) var dismiss
    
    @ObservedResults(TransactionItem.self) var transactions
    @ObservedResults(Category.self) var categories
    
    @AppStorage("currencySymbol") private var currencySymbol: String = "USD"
    @AppStorage("playFeedbackHaptic") private var selectedFeedbackHaptic: Bool = true
    
    var body: some View {
        NavigationStack {
            List {
                if transactions.isEmpty {
                    previewCard()
                } else {
                    let groupedTransactions = transactionsByDate(Array(transactions))
                    
                    ForEach(groupedTransactions.keys.sorted(by: { $0 > $1 }), id: \.self) { date in
                        Section(header: Text(date, style: .date).bold()) {
                            let sortedTransactions = sortTransactionsByDate(transactions: groupedTransactions[date]!)
                            
                            ForEach(sortedTransactions, id: \.self) { transaction in
                                if let category = filterCategories(categories: Array(categories), transaction: transaction) {
                                    transactionRow(transaction: transaction, category: category)
                                }
                            }
                            .onDelete(perform: { indexSet in
                                deleteTransaction(at: indexSet, from: sortedTransactions)
                                playFeedbackHaptic(selectedFeedbackHaptic)
                            })
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color("colorBG"))
            .navigationBarTitle("Transactions", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        playFeedbackHaptic(selectedFeedbackHaptic)
                        dismiss()
                    } label: {
                        Text("Back")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if transactions.isEmpty {
                        EditButton().disabled(true)
                    } else {
                        EditButton()
                    }
                }
            }
        }
    }
    
    // Метод для оптимизации отображения списка
    private func transactionRow(transaction: TransactionItem, category: Category) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HStack {
                    Divider()
                        .foregroundColor(Color(category.color))
                        .frame(width: 5, height: 72)
                        .background(Color(category.color))
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
                            Text(category.name)
                                .foregroundColor(Color("colorBalanceText")).textCase(.uppercase)
                                .font(.caption)
                                .multilineTextAlignment(.trailing)
                                .dynamicTypeSize(.small)
                                .padding(0)
                            Image(systemName: category.icon)
                                .font(.caption).dynamicTypeSize(.small)
                                .foregroundColor(.black)
                                .frame(width: 20, height: 20)
                                .background(Color(category.color))
                                .cornerRadius(5)
                                .padding(0)
                        } .padding(0)
                    }
                    HStack {
                        Text(transaction.note)
                            .foregroundColor(Color(.gray)).textCase(.uppercase)
                            .font(.subheadline).dynamicTypeSize(.small)
                        Spacer()
                        Text(category.type.localizedName())
                            .foregroundColor(Color(.gray)).textCase(.uppercase)
                            .font(.subheadline).dynamicTypeSize(.small)
                    }
                }    .padding(.leading, 10)
            }
        }
        .padding(.vertical, 5)
        .frame(height: 50)
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
    
    // Метод фильтрации категорий
    private func filterCategories(categories: [Category], transaction: TransactionItem) -> Category? {
        for category in categories {
            if category.id == transaction.categoryId {
                return category
            }
        }
        return nil
    }
    
    // метод сортировки транзакций по дате
    private func sortTransactionsByDate(transactions: [TransactionItem]) -> [TransactionItem] {
        return transactions.sorted(by: { $0.date > $1.date })
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView()
            .environmentObject(SceneViewModel())
    }
}
