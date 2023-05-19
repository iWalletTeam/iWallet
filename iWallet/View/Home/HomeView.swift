//  ContentView.swift

import SwiftUI
import RealmSwift

struct HomeView: View {
    @EnvironmentObject var viewModel: SceneViewModel
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
                        
                        BalanceView(amount: viewModel.balance(), curren: currencySymbol, type: NSLocalizedString("Balance", comment: "Balance"), icon: "equal.circle", viewBG: Color("colorBalanceBG"), amountBG: Color("colorBalanceText"), typeBG: .gray, iconBG: Color("colorBlue"))
                        
                        BalanceView(amount: viewModel.averageDailyExpense(), curren: currencySymbol, type: NSLocalizedString("Expense average", comment: "Expense average"), icon: "plusminus.circle", viewBG: Color("colorBalanceBG"), amountBG: Color("colorBalanceText"), typeBG: .gray, iconBG: Color("colorYellow"))
                            .frame(height: expenseHeight)
                        
                        BalanceView(amount: viewModel.totalIncomes(), curren: currencySymbol, type: NSLocalizedString("Income", comment: "Income"), icon: "plus.circle", viewBG: Color("colorBalanceBG"), amountBG: Color("colorBalanceText"), typeBG: .gray, iconBG: Color("colorGreen"))
                            .frame(height: expenseHeight)
                        
                        BalanceView(amount: viewModel.totalExpenses(), curren: currencySymbol, type: NSLocalizedString("Expense", comment: "Expense"), icon: "minus.circle", viewBG: Color("colorBalanceBG"), amountBG: Color("colorBalanceText"), typeBG: .gray, iconBG: Color("colorRed"))
                        
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
                    .background(Color("colorBalanceBG"))
                    .cornerRadius(10)
                    .padding(.horizontal, 15)
                    
                    VStack(spacing: 0) {
                        // создаем массив транзакций по категориями
                        let categoriesWithTransactionsArray = categoriesWithTransaction(categories: categories)
                        
                        // фильтруем категории по типу
                        var filteredCategoriesArray =  filteredCategories(categories: categoriesWithTransactionsArray, type: selectedCategoryType)
                        
                        // сортируем категории по сумме
                        let _: () = filteredCategoriesArray.sort(by: { $0.categoryAmount(type: selectedCategoryType) > $1.categoryAmount(type: selectedCategoryType)})
                        
                        if filteredCategoriesArray.isEmpty {
                            previewCard()
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .background(Color("colorBalanceBG"))
                            
                        } else {
                            
                            ForEach(filteredCategoriesArray, id: \.self) { category in
                                let totalAmount = category.categoryAmount(type: selectedCategoryType)
                                NavigationLink(destination: TransactionCategoryView(selectedCategory: .constant(category))) {
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack {
                                            HStack {
                                                Divider()
                                                    .foregroundColor(Color(category.color))
                                                    .frame(width: 5, height: 50)
                                                    .background(Color(category.color))
                                            }
                                            
                                            Image(systemName: category.icon)
                                                .font(.system(size: 15))
                                                .foregroundColor(.black)
                                                .frame(width: 30, height: 30)
                                                .background(Color(category.color))
                                                .cornerRadius(7.5)
                                                .padding(0)
                                            
                                            Text(category.name)
                                                .font(.headline)
                                                .fontWeight(.light)
                                                .foregroundColor(Color("colorBalanceText"))
                                            
                                            Spacer()
                                            
                                            Text("\(totalAmount.formattedWithSeparatorAndCurrency()) \(currencySymbol)")
                                                .font(.headline).bold()
                                                .foregroundColor(Color("colorBalanceText"))
                                            
                                            Image(systemName: "chevron.forward")
                                                .foregroundColor(Color("colorBalanceText"))
                                                .opacity(0.5)
                                            
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, maxHeight: 50)
                                        .background(Color("colorBalanceBG"))
                                        
                                        Divider()
                                    }
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
            AddTransaction(selectedCategory: Category())
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
        let viewModel = SceneViewModel()
        let cofiguration = Realm.Configuration(inMemoryIdentifier: "Preview")
        
        HomeView()
            .environmentObject(viewModel)
            .environment(\.realmConfiguration, cofiguration)
    }
}
