//  ContentView.swift

import SwiftUI
import RealmSwift

struct HomeView: View {
    @EnvironmentObject var transactionVM: TransactionViewModel
    @ObservedResults(Category.self) var categories
    
    @AppStorage("currencySymbol") private var currencySymbol: String = "USD"
    @AppStorage("playFeedbackHaptic") private var selectedFeedbackHaptic: Bool = true
    
    @State private var showSettingView: Bool = false
    @State private var showAddTransaction: Bool = false
    @State private var selectedCategoryType: CategoryType = .expense
    @State private var expenseHeight: CGFloat = 0
    
    private let adaptive =
    [
        GridItem(.adaptive(minimum: 165))
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: adaptive) {
                        
                        BalanceView(amount: transactionVM.balance(), curren: currencySymbol, type: NSLocalizedString("Balance", comment: "Balance"), icon: "equal.circle", iconBG: Color(Colors.colorBlue))
                        
                        BalanceView(amount: transactionVM.averageDailyExpense(), curren: currencySymbol, type: NSLocalizedString("Expense average", comment: "Expense average"), icon: "plusminus.circle", iconBG: Color(Colors.colorYellow))
                        
                        BalanceView(amount: transactionVM.totalIncomes(), curren: currencySymbol, type: NSLocalizedString("Income", comment: "Income"), icon: "plus.circle", iconBG: Color(Colors.colorGreen))
                        
                        BalanceView(amount: transactionVM.totalExpenses(), curren: currencySymbol, type: NSLocalizedString("Expense", comment: "Expense"), icon: "minus.circle", iconBG: Color(Colors.colorRed))
                        
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
                        let categoriesWithTransactionsArray = categoriesWithTransaction(categories: categories)
                        
                        // фильтруем категории по типу
                        let filteredCategoriesArray =  filteredCategories(categories: categoriesWithTransactionsArray, type: selectedCategoryType)
                        
                        if filteredCategoriesArray.isEmpty {
                            previewCard()
                        } else {
                            
                            ForEach(filteredCategoriesArray, id: \.self) { category in
                                let totalAmount = category.categoryAmount(type: selectedCategoryType)
                                NavigationLink(destination: TransactionCategoryView(selectedCategory: .constant(category))) {
                                    
                                    CategoryItemView(categoryColor: category.color, categoryIcon: category.icon, categoryName: category.name, totalAmount: totalAmount, currencySymbol: currencySymbol)
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
                        playFeedbackHaptic(selectedFeedbackHaptic)
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
                            withAnimation {
                                playFeedbackHaptic(selectedFeedbackHaptic)
                                showSettingView.toggle()
                            }
                        } label: {
                            Text("Settings")
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
        .sheet(isPresented: $showSettingView) {
            SettingView()
        }
        .sheet(isPresented: $showAddTransaction) {
            AddTransaction(selectedCategory: Category(), selectedType: selectedCategoryType)
        }
    }
    
    // Функция которая фильтрует список категорий, чтобы найти только те, которые имеют транзакции определенного типа.
    private func categoriesWithTransaction(categories: Results<Category>) -> [Category] {
        var result: [Category] = []
        for category in categories {
            if category.hasTransactions(type: selectedCategoryType) {
                result.append(category)
            }
        }
        return result
    }
    
    // Функция фильтрует категории из массива categories, сохраняя только те, сумма транзакций которых для заданного типа type (доход или расход) больше 0
    private func filteredCategories(categories: [Category], type: CategoryType) -> [Category] {
        var result: [Category] = []
        for category in categories {
            if category.categoryAmount(type: type) > 0 {
                result.append(category)
            }
        }
        return result
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AppViewModel()
        let transactionVM = TransactionViewModel()
        let cofiguration = Realm.Configuration(inMemoryIdentifier: "Preview")
        
        HomeView()
            .environmentObject(viewModel)
            .environmentObject(transactionVM)
            .environment(\.realmConfiguration, cofiguration)
    }
}
