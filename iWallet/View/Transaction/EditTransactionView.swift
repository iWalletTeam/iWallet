//
//  EditTransactionView.swift
//  iWallet
//
//  Created by Vladislav Novoshinskiy on 13.06.2023.
//

import SwiftUI
import RealmSwift

struct EditTransactionView: View {
    @EnvironmentObject private var appVM: AppViewModel
    @EnvironmentObject private var transactionVM: TransactionViewModel
    @EnvironmentObject private var categoryVM: CategoryViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State var selectedTransaction: TransactionItem
    @State private var alertAmount: Bool = false
    
    @FocusState private var amountIsFocused: Bool
    @FocusState private var noteIsFocused: Bool
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                Section {
                    TextField(selectedTransaction.type == .expense ? "-100 \(appVM.currencySymbol)" : "+100 \(appVM.currencySymbol)", value: $selectedTransaction.amount, formatter: formatter)
                        .font(.title3)
                        .keyboardType(appVM.roundingNumbers ? .numberPad : .decimalPad)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("colorBalanceBG"))
                        .cornerRadius(10)
                        .padding(.bottom, 15)
                        .focused($amountIsFocused)
                } header: {
                    Text("Enter amount:")
                        .font(.caption).textCase(.uppercase)
                        .padding(.leading, 10)
                }
                .onTapGesture {
                    amountIsFocused.toggle()
                }
                
                Section {
                    TextField("Note", text: $selectedTransaction.note)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("colorBalanceBG"))
                        .cornerRadius(10)
                        .focused($noteIsFocused)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            // находит категорию в которую была записана транзакция
                            let categoryResult = categorySearch(categories: categoryVM.categories)
                            
                            // находит все заметки в той категории в которую была записанна транзакция
                            let filterTransaction = transactionVM.filterTransactionsNote(category: categoryResult, transactions: transactionVM.transactions)
                            
                            ForEach(filterTransaction.reversed(), id: \.self) { notes in
                                Button {
                                    selectedTransaction.note = notes.note
                                } label: {
                                    Text(String(notes.note.prefix(20)))
                                        .font(Font.caption)
                                        .foregroundColor(Color(.systemGray2))
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 7, style: .continuous)
                                                .strokeBorder(Color(.systemGray2))
                                        )
                                        .padding(.bottom, 10)
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                } header: {
                    Text("Enter note:")
                        .font(.caption).textCase(.uppercase)
                        .padding(.leading, 10)
                }
                .onTapGesture {
                    noteIsFocused.toggle()
                }
                
                Section {
                    HStack {
                        DatePicker("Date", selection: $selectedTransaction.date, displayedComponents: .date)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("colorBalanceBG"))
                    .cornerRadius(10)
                } header: {
                    Text("Enter date:")
                        .font(.caption).textCase(.uppercase)
                        .padding(.leading, 10)
                        .padding(.top, 10)
                }
            }
            .padding(.horizontal, 15)
            .padding(.top, 20)
        }
        .navigationBarTitle("Editing", displayMode: .inline)
        .scrollDismissesKeyboard(.immediately)
        .background(Color("colorBG"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if selectedTransaction.amount.formattedWithSeparatorAndCurrency(roundingNumbers: appVM.roundingNumbers).count == 0 {
                        alertAmount = true
                    } else {
                        playFeedbackHaptic(appVM.selectedFeedbackHaptic)
                        dismiss()
                    }
                } label: {
                    Text("Edit")
                }
            }
        }
        .alert("Please enter amount", isPresented: $alertAmount) {
            Button("Okay", role: .cancel) { }
        }
    }
    
    // находит категорию в которую была записана транзакция
    func categorySearch(categories: [Category]) -> Category {
        var result = Category()
        
        for category in categories {
            if category.id == selectedTransaction.categoryId {
                if category.hasTransactions(type: selectedTransaction.type) {
                    result = category
                }
            }
        }
        return result
    }
}

struct EditTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        EditTransactionView(selectedTransaction: TransactionItem())
    }
}
