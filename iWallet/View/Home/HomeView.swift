//  ContentView.swift

import SwiftUI
import RealmSwift

struct HomeView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var categoryVM: CategoryViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    @ObservedResults(Category.self) var categories
    
    @State private var showAddTransaction: Bool = false
    @State private var selectedCategoryType: CategoryType = .expense
    
    private let adaptive =
    [
        GridItem(.adaptive(minimum: 165))
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: adaptive) {
                        
                        BalanceView(amount: transactionVM.balance(), curren: appVM.currencySymbol, type: NSLocalizedString("Balance", comment: "Balance"), icon: "equal.circle", iconBG: Color(Colors.colorBlue))
                        
                        BalanceView(amount: transactionVM.averageDailyExpense(), curren: appVM.currencySymbol, type: NSLocalizedString("Expense average", comment: "Expense average"), icon: "plusminus.circle", iconBG: Color(Colors.colorYellow))
                        
                        BalanceView(amount: transactionVM.totalIncomes(), curren: appVM.currencySymbol, type: NSLocalizedString("Income", comment: "Income"), icon: "plus.circle", iconBG: Color(Colors.colorGreen))
                        
                        BalanceView(amount: transactionVM.totalExpenses(), curren: appVM.currencySymbol, type: NSLocalizedString("Expense", comment: "Expense"), icon: "minus.circle", iconBG: Color(Colors.colorRed))
                        
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Picker("Тип", selection: $selectedCategoryType) {
                        ForEach(CategoryType.allCases, id: \.self) { type in
                            Text(type.localizedName())
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(Colors.colorBalanceBG))
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
                    
                    VStack(spacing: 0) {
                        // создаем массив транзакций по категориями
                        let categoriesWithTransactionsArray = categoryVM.categoriesWithTransaction(categories: categories, type: selectedCategoryType)
                        
                        // фильтруем категории по типу
                        var filteredCategoriesArray =  categoryVM.filteredCategories(categories: categoriesWithTransactionsArray, type: selectedCategoryType)
                        
                        // сортируем категории по сумме
                        let _: () = filteredCategoriesArray.sort(by: { $0.categoryAmount(type: selectedCategoryType) > $1.categoryAmount(type: selectedCategoryType)})
                        
                        if filteredCategoriesArray.isEmpty {
                            previewHomeTransaction()
                        } else {
                            
                            ForEach(filteredCategoriesArray, id: \.self) { category in
                                let totalAmount = category.categoryAmount(type: selectedCategoryType)
                                NavigationLink(destination: TransactionCategoryView(selectedCategory: .constant(category))) {
                                    
                                    CategoryItemView(categoryColor: category.color, categoryIcon: category.icon, categoryName: category.name, totalAmount: totalAmount, currencySymbol: appVM.currencySymbol)
                                }
                            }
                        }
                    }
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 100)
                }
                
                
                HStack {
                    Button {
                        playFeedbackHaptic(appVM.selectedFeedbackHaptic)
                        showAddTransaction.toggle()
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 55, height: 55)
                                .foregroundColor(Color("colorBalanceText"))
                            Image(systemName: "plus")
                                .foregroundColor(Color("colorBG"))
                                .font(.system(size: 30))
                        }
                    }
                }
                .padding(.all, 25)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            playFeedbackHaptic(appVM.selectedFeedbackHaptic)
                        } label: {
                            NavigationLink(destination: SettingView(), label: {
                                HStack {
                                    Text("Settings")
                                }
                            })
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("iWallet")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("colorBalanceText"))
                    }
                }
            }
            .background(Color("colorBG"))
        }
        .sheet(isPresented: $showAddTransaction) {
            AddTransaction(selectedCategory: Category(), selectedType: selectedCategoryType)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppViewModel())
            .environmentObject(TransactionViewModel())
    }
}
