//  AddCategoryView.swift

import SwiftUI
import RealmSwift

struct CategoryView: View {
    @EnvironmentObject var viewModel: SceneViewModel
    @ObservedResults(Category.self) var categories
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("playFeedbackHaptic") private var selectedFeedbackHaptic: Bool = true
    
    @State var selectedType: CategoryType = .expense
    @State var showAddCategory: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    if filteredCategories().isEmpty {
                        VStack(alignment: .center) {
                            Spacer(minLength: 20)
                            Image("icon")
                                .resizable()
                                .frame(width: 25, height: 25)
                            Spacer()
                            Text("iWallet")
                                .foregroundColor(.gray).bold()
                                .font(.title)
                            Text("Welcome")
                                .foregroundColor(.gray)
                            Spacer(minLength: 20)
                            
                            Text("The list of categories is currently")
                                .foregroundColor(.gray)
                                .font(.system(size: 12))
                            Text("please add category.")
                                .foregroundColor(.gray)
                                .font(.system(size: 12))
                            Spacer(minLength: 20)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 300)
                    } else {
                        ForEach(filteredCategories(), id: \.self) { category in
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
                        } .onDelete(perform: deleteCategory)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color("colorBG"))
            }
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
                    Button {
                        playFeedbackHaptic(selectedFeedbackHaptic)
                        showAddCategory.toggle()
                    } label: {
                        Text("New")
                    }
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
        .sheet(isPresented: $showAddCategory) {
            AddCategory()
        }
    }
    
    private func filteredCategories() -> [Category] {
        return categories.filter { $0.type == selectedType
        }
    }
    
    private func deleteCategory(at offsets: IndexSet) {
        let filtered = filteredCategories()
        offsets.forEach { index in
            viewModel.deleteCategory(id: filtered[index].id)
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SceneViewModel()
        let cofiguration = Realm.Configuration(inMemoryIdentifier: "Preview")
        
        CategoryView()
            .environmentObject(viewModel)
            .environment(\.realmConfiguration, cofiguration)
    }
}
