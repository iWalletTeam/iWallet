//  AddTransaction.swift

import SwiftUI
import RealmSwift

struct AddTransaction: View {
    @EnvironmentObject var viewModel: SceneViewModel
    @Environment(\.dismiss) var dismiss
    @ObservedResults(Category.self) var categories
    
    @AppStorage("currencySymbol") private var currencySymbol: String = "USD"
    @AppStorage("playFeedbackHaptic") private var selectedFeedbackHaptic: Bool = true
    @FocusState private var amountIsFocused: Bool
    @FocusState private var noteIsFocused: Bool
    @FocusState private var keyIsFocused: Bool
    
    @State var selectedCategory: Category
    @State var amount: String = ""
    @State var date: Date = Date()
    @State var note: String = ""
    @State var selectedType: CategoryType = .expense
    @State var alertAmount: Bool = false
    @State var alertCategory: Bool = false
    
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                        Section {
                            if selectedType == .expense {
                                TextField("-100 \(currencySymbol)", text: $amount)
                                    .font(.title3)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color("colorBalanceBG"))
                                    .cornerRadius(10)
                                    .padding(.bottom, 15)
                                    .focused($amountIsFocused)
                            } else {
                                TextField("+100 \(currencySymbol)", text: $amount)
                                    .font(.title3)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color("colorBalanceBG"))
                                    .cornerRadius(10)
                                    .padding(.bottom, 15)
                                    .focused($amountIsFocused)
                            }
                        } header: {
                            Text("Enter amount:")
                                .font(.caption).textCase(.uppercase)
                                .padding(.leading, 10)
                        }
                        .onTapGesture {
                            amountIsFocused.toggle()
                        }
                        
                        Section {
                            TextField("Note", text: $note)
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color("colorBalanceBG"))
                                .cornerRadius(10)
                                .padding(.bottom, 15)
                                .focused($noteIsFocused)
                        } header: {
                            Text("Enter note:")
                                .font(.caption).textCase(.uppercase)
                                .padding(.leading, 10)
                        }
                        .onTapGesture {
                            noteIsFocused.toggle()
                        }
                    
                    Section {
                        Picker("Category type", selection: $selectedType) {
                            ForEach(CategoryType.allCases, id: \.self) { type in
                                Text(type.localizedName())
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("colorBalanceBG"))
                        .cornerRadius(10)
                        
                        HStack {
                            Picker("Category", selection: $selectedCategory) {
                                ForEach(categories.filter { $0.type == selectedType }, id: \.self) { category in
                                    HStack {
                                        Image(systemName: category.icon)
                                            .foregroundColor(Color(.black))
                                            .frame(width: 30, height: 30)
                                            .background(Color(category.color))
                                            .cornerRadius(7.5)
                                        Text(category.name)
                                            .foregroundColor(Color("colorBalanceText"))
                                    }
                                }
                            }
                            .foregroundColor(Color("colorBalanceText"))
                            .pickerStyle(.navigationLink)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color("colorBalanceBG"))
                            .cornerRadius(10)
                            .padding(.bottom, 15)
                        }
                    } header: {
                        Text("Purpose:")
                            .font(.caption).textCase(.uppercase)
                            .padding(.leading, 10)
                    }
                    Section {
                        HStack {
                            DatePicker("Date", selection: $date, displayedComponents: .date)
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
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 20)
                
            }
            .scrollDismissesKeyboard(.immediately)
            .background(Color("colorBG"))
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        playFeedbackHaptic(selectedFeedbackHaptic)
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if amount.isEmpty {
                            alertAmount = true
                        } else if selectedCategory.name == "" {
                            alertCategory = true
                        } else {
                            playFeedbackHaptic(selectedFeedbackHaptic)
                            viewModel.saveTransaction(amount: Float(amount) ?? 0, date: date, note: note, type: selectedType, category: selectedCategory)
                            dismiss()
                        }
                    } label: {
                        Text("Add")
                    }
                    .alert("Please select a category", isPresented: $alertCategory) {
                        Button("Okay", role: .cancel) { }
                    }
                    .alert("Please enter amount", isPresented: $alertAmount) {
                        Button("Okay", role: .cancel) { }
                    }
                }
            }
        }
    }
}

struct AddTransaction_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SceneViewModel()
        let cofiguration = Realm.Configuration(inMemoryIdentifier: "Preview")
        
        AddTransaction(selectedCategory: Category())
            .environmentObject(viewModel)
            .environment(\.realmConfiguration, cofiguration)
    }
}
