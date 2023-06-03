//
//  PickerCategoryView.swift
//  iWallet
//
//  Created by Vladislav Novoshinskiy on 03.06.2023.
//

import SwiftUI
import RealmSwift

struct PickerCategoryView: View {
    @ObservedResults(Category.self) var categories
    @Environment(\.dismiss) var dismiss
    
    @Binding var selected: Category
    @State var selectedType: CategoryType = .expense
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                if categories.filter({ $0.type == selectedType }).isEmpty {
                    VStack {
                        VStack {
                            previewNoCategory()
                        }
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        HStack {
                            NavigationLink(destination: AddCategory(selectedType: selectedType), label: {
                                HStack {
                                    Text("Create category")
                                }
                            })
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(Color(Colors.colorBalanceBG))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(categories.filter { $0.type == selectedType }, id: \.name) { category in
                            Button {
                                selected = category
                                dismiss()
                            } label: {
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
                                        .foregroundColor(Color(Colors.mainText))
                                    
                                    Spacer()
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color(Colors.colorBalanceBG))
                            
                            Divider()
                        }
                    }
                    .cornerRadius(10)
                    .padding()
                }
            }
            .background(Color(Colors.mainBG))
            .navigationTitle("Categories")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PickerCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        PickerCategoryView(selected: .constant(Category(value: ["name": NSLocalizedString("Interest on accounts", comment: "Interest on accounts"), "icon": "percent", "color": "colorYellow", "type": CategoryType.income] as [String : Any])))
    }
}
