//  TransactionView.swift

import SwiftUI
import RealmSwift

struct TransactionView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    @Environment(\.dismiss) var dismiss
    
    @ObservedResults(TransactionItem.self) var transactions
    @ObservedResults(Category.self) var categories
    
    var body: some View {
        NavigationStack {
            List {
                if transactions.isEmpty {
                    previewCardTransaction()
                } else {
                    let groupedTransactions = transactionVM.transactionsByDate(Array(transactions))
                    ForEach(groupedTransactions.keys.sorted(by: { $0 > $1 }), id: \.self) { date in
                        Section(header: Text(date, style: .date).bold()) {
                            let sortedTransactions = transactionVM.sortTransactionsByDate(transactions: groupedTransactions[date]!)
                            
                            ForEach(sortedTransactions, id: \.self) { transaction in
                                if let category = transactionVM.filterCategories(categories: Array(categories), transaction: transaction) {
                                    transactionRow(transaction: transaction, category: category)
                                }
                            }
                            .onDelete(perform: { indexSet in
                                transactionVM.deleteTransaction(at: indexSet, from: sortedTransactions)
                                playFeedbackHaptic(appVM.selectedFeedbackHaptic)
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
                        playFeedbackHaptic(appVM.selectedFeedbackHaptic)
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
    @ViewBuilder
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
                            Text("-\(transaction.amount.formattedWithSeparatorAndCurrency()) \(appVM.currencySymbol)")
                                .font(.title3).bold()
                        } else {
                            Text("\(transaction.amount.formattedWithSeparatorAndCurrency()) \(appVM.currencySymbol)")
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
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView()
            .environmentObject(AppViewModel())
    }
}
