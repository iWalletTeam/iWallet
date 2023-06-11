//  SettingView.swift

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var appVM: AppViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    @State private var selectedCurrency: Currency = .usd
    @State private var showCategory: Bool = false
    @State private var showTransactionView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        Button {
                            playFeedbackHaptic(appVM.selectedFeedbackHaptic)
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
                            playFeedbackHaptic(appVM.selectedFeedbackHaptic)
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
                            Text(selectedCurrency.symbol)
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
                            Image(systemName: appVM.selectedFeedbackHaptic ? "iphone.radiowaves.left.and.right.circle" : "iphone.slash.circle")
                                .foregroundColor(Color("colorBlack"))
                                .frame(width: 30, height: 30)
                                .background(Color("colorPurple2"))
                                .cornerRadius(7.5)
                            Toggle("Vibration", isOn: $appVM.selectedFeedbackHaptic)
                        }
                    }
                    
                    Section {
                        Button {
                            playFeedbackHaptic(appVM.selectedFeedbackHaptic)
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
                            playFeedbackHaptic(appVM.selectedFeedbackHaptic)
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
                VStack {
                    Image(systemName: "exclamationmark.shield")
                    Text("App version: 1.1.5")
                }
                .font(.caption2).bold()
                .padding()
            }
            .navigationTitle("Settings")
            .scrollContentBackground(.hidden)
            .background(Color("colorBG"))
            .onAppear {
                // Устанавливаем selectedCurrency на основе сохраненного символа валюты
                if let currency = Currency.allCases.first(where: { $0.symbol == appVM.currencySymbol }) {
                    selectedCurrency = currency
                }
            }
            .onChange(of: selectedCurrency) { newCurrency in
                // Сохраняем символ валюты при изменении выбора
                appVM.currencySymbol = newCurrency.symbol
                playFeedbackHaptic(appVM.selectedFeedbackHaptic)
            }
            .fullScreenCover(isPresented: $showCategory) {
                CategoryView()
            }
            .sheet(isPresented: $showTransactionView) {
                TransactionView()
            }
        }
    }
}


struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(AppViewModel())
    }
}
