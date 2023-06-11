//  AddCategoryView.swift

import SwiftUI
import RealmSwift

struct CategoryView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var categoryVM: CategoryViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    @ObservedResults(Category.self) var categories
    @Environment(\.dismiss) var dismiss
    
    @State var selectedType: CategoryType = .expense
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    if categoryVM.filteredCategory(category: categories, type: selectedType).isEmpty {
                        previewCardCategory()
                    } else {
                        ForEach(categoryVM.filteredCategory(category: categories, type: selectedType), id: \.self) { category in
                            HStack {
                                Image(systemName: category.icon)
                                    .font(.system(size: 15))
                                    .foregroundColor(Color(.black))
                                    .frame(width: 30, height: 30)
                                    .background(Color(category.color))
                                    .cornerRadius(7.5)
                                Text(category.name)
                                    .foregroundColor(Color("colorBalanceText"))
                            }
                        }
                        .onDelete(perform: { indexSet in
                            categoryVM.deleteCategories(category: categories, at: indexSet, type: selectedType, transaction: transactionVM)
                            playFeedbackHaptic(appVM.selectedFeedbackHaptic)
                        })
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color("colorBG"))
            }
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
                    NavigationLink(destination: AddCategoryView(selectedType: selectedType), label: {
                        Text("New")
                    })
                }
                ToolbarItem(placement: .principal) {
                    Picker("Type", selection: $selectedType) {
                        ForEach(CategoryType.allCases, id: \.self) { type in
                            Text(type.localizedName())
                        }
                    } .pickerStyle(.segmented)
                }
            }
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
            .environmentObject(AppViewModel())
            .environmentObject(TransactionViewModel())
            .environmentObject(CategoryViewModel())
    }
}
