//  SettingView.swift

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var viewModel: SceneViewModel
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    @AppStorage("currencySymbol") private var currencySymbol: String = "USD"
    @AppStorage("playFeedbackHaptic") private var selectedFeedbackHaptic: Bool = true
    
    @State private var selectedCurrency: Currency = .usd
    @State var showCategory: Bool = false
    @State var showTransactionView: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        playFeedbackHaptic(selectedFeedbackHaptic)
                        showTransactionView.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "clock.circle")
                                .foregroundColor(Color("colorBlack"))
                                .frame(width: 30, height: 30)
                                .background(Color("colorYellow"))
                                .cornerRadius(7.5)
                            Text("Transactions")
                                .foregroundColor(Color("colorBalanceText"))
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .foregroundColor(Color("colorBalanceText"))
                                .opacity(0.5)
                        }
                    }
                    
                    Button {
                        playFeedbackHaptic(selectedFeedbackHaptic)
                        showCategory.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "list.bullet.circle")
                                .foregroundColor(Color("colorBlack"))
                                .frame(width: 30, height: 30)
                                .background(Color("colorBlue"))
                                .cornerRadius(7.5)
                            Text("Categories")
                                .foregroundColor(Color("colorBalanceText"))
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .foregroundColor(Color("colorBalanceText"))
                                .opacity(0.5)
                        }
                    }
                } header: {
                    Text("Data")
                }
                
                Section(header: Text("Application")) {
                    HStack {
                        Text(selectedCurrency.symbol) // Используйте selectedCurrency.symbol
                            .foregroundColor(Color("colorBlack"))
                            .frame(width: 30, height: 30)
                            .background(Color("colorBrown1"))
                            .cornerRadius(7.5)
                        Picker("Currency", selection: $selectedCurrency) {
                            ForEach(Currency.sortedCases, id: \.self) { currency in
                                Text(currency.rawValue)
                                    .tag(currency)
                            }
                        }
                    }
                    HStack {
                        Image(systemName: selectedFeedbackHaptic ? "iphone.radiowaves.left.and.right.circle" : "iphone.slash.circle")
                            .foregroundColor(Color("colorBlack"))
                            .frame(width: 30, height: 30)
                            .background(Color("colorPurple2"))
                            .cornerRadius(7.5)
                        Toggle("Vibration", isOn: $selectedFeedbackHaptic)
                    }
                }
                
                Section {
                    Button {
                        playFeedbackHaptic(selectedFeedbackHaptic)
                        openURL(URL(string: NSLocalizedString("https://idevnva.com/", comment: "https://idevnva.com/"))!)
                    } label: {
                        HStack {
                            Image(systemName: "network")
                                .foregroundColor(Color("colorBlack"))
                                .frame(width: 30, height: 30)
                                .background(Color("colorRed"))
                                .cornerRadius(7.5)
                            Text("Web-site")
                                .foregroundColor(Color("colorBalanceText"))
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .foregroundColor(Color("colorBalanceText"))
                                .opacity(0.5)
                        }
                    }
                    
                    Button {
                        playFeedbackHaptic(selectedFeedbackHaptic)
                        openURL(URL(string: NSLocalizedString("https://t.me/iwalletapp", comment: "https://t.me/iwalletapp"))!)
                    } label: {
                        HStack {
                            Image(systemName: "person.2.circle")
                                .foregroundColor(Color("colorBlack"))
                                .frame(width: 30, height: 30)
                                .background(Color("colorGreen"))
                                .cornerRadius(7.5)
                            Text("Community")
                                .foregroundColor(Color("colorBalanceText"))
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .foregroundColor(Color("colorBalanceText"))
                                .opacity(0.5)
                        }
                    }
                    
                    Button {
                        playFeedbackHaptic(selectedFeedbackHaptic)
                        openURL(URL(string: NSLocalizedString("https://t.me/idevnva", comment: "https://t.me/idevnva"))!)
                    } label: {
                        HStack {
                            Image(systemName: "envelope.circle")
                                .foregroundColor(Color("colorBlack"))
                                .frame(width: 30, height: 30)
                                .background(Color("colorGray1"))
                                .cornerRadius(7.5)
                            Text("Write to the developer")
                                .foregroundColor(Color("colorBalanceText"))
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .foregroundColor(Color("colorBalanceText"))
                                .opacity(0.5)
                        }
                    }
                } header: {
                    Text("Feedback")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color("colorBG"))
            .navigationTitle("Settings")
            .onAppear {
                // Устанавливаем selectedCurrency на основе сохраненного символа валюты
                if let currency = Currency.allCases.first(where: { $0.symbol == currencySymbol }) {
                    selectedCurrency = currency
                }
            }
            .onChange(of: selectedCurrency) { newCurrency in
                // Сохраняем символ валюты при изменении выбора
                currencySymbol = newCurrency.symbol
                playFeedbackHaptic(selectedFeedbackHaptic)
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
            }
        }
        .fullScreenCover(isPresented: $showCategory) {
            CategoryView()
        }
        .sheet(isPresented: $showTransactionView) {
            TransactionView()
        }
    }
}


struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
