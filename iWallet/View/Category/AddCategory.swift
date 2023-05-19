//  AddCategory.swift

import SwiftUI

struct AddCategory: View {
    @EnvironmentObject var viewModel: SceneViewModel
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("playFeedbackHaptic") private var selectedFeedbackHaptic: Bool = true
    @FocusState private var nameIsFocused: Bool
    
    @State private var selectedType: CategoryType = .expense
    @State private var name: String = ""
    @State private var selectedImage: String = "folder.circle"
    @State private var selectedColor: String = "colorBlue"
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Spacer()
                            Image(systemName: selectedImage)
                                .foregroundColor(Color(.black))
                                .font(.system(size: 50))
                                .frame(width: 100, height: 100)
                                .background(Color(selectedColor))
                                .cornerRadius(25)
                            Spacer()
                        } .padding(.bottom, 15)
                        
                        Section {
                            VStack(alignment: .leading) {
                                Picker("Type", selection: $selectedType) {
                                    ForEach(CategoryType.allCases, id: \.self) { type in
                                        Text(type.localizedName())
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color("colorBalanceBG"))
                                .cornerRadius(10)
                                .padding(.bottom, 15)
                            }
                        } header: {
                            Text("Select type:")
                                .font(.caption).textCase(.uppercase)
                                .padding(.leading, 10)
                        }
                        
                        Section {
                            VStack(alignment: .leading) {
                                TextField("Name", text: $name)
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color("colorBalanceBG"))
                                    .cornerRadius(10)
                                    .padding(.bottom, 15)
                                    .focused($nameIsFocused)
                            }
                        } header: {
                            Text("Enter Name")
                                .font(.caption).textCase(.uppercase)
                                .padding(.leading, 10)
                        }
                        .onTapGesture {
                            nameIsFocused.toggle()
                        }
                        
                        Section {
                            IconPicker(selectedImage: $selectedImage)
                                .foregroundColor(Color(.black))
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color("colorBalanceBG"))
                                .cornerRadius(10)
                                .padding(.bottom, 15)
                        } header: {
                            Text("Choose an icon:")
                                .font(.caption).textCase(.uppercase)
                                .padding(.leading, 10)
                        }
                        Section {
                            ColorPicker(selectedColor: $selectedColor)
                                .padding(5)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color("colorBalanceBG"))
                                .cornerRadius(10)
                            
                        } header: {
                            Text("Choose color:")
                                .font(.caption).textCase(.uppercase)
                                .padding(.leading, 10)
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.top, 20)
                }
            }
            .background(Color("colorBG"))
            .navigationBarTitle("Create a category", displayMode: .inline)
            .scrollDismissesKeyboard(.immediately)
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
                        if name.isEmpty {
                            
                        } else {
                            playFeedbackHaptic(selectedFeedbackHaptic)
                            viewModel.saveCategory(name: name, icon: selectedImage, color: selectedColor, type: selectedType)
                            dismiss()
                        }
                    } label: {
                        if name.isEmpty {
                            Text("Add")
                                .foregroundColor(.gray)
                        } else {
                            Text("Add")
                        }
                    }
                }
            }
        }
    }
}

struct AddCategory_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SceneViewModel()
        
        AddCategory()
            .environmentObject(viewModel)
    }
}
