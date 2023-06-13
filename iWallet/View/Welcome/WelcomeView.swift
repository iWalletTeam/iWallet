//  WelcomeView.swift

import SwiftUI
import RealmSwift

struct WelcomeView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var categoryVM: CategoryViewModel
    
    @State private var selectedCurrency: Currency = .usd
    @State private var createCategories: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center) {
                        VStack {
                            Spacer(minLength: 100)
                            Image("icon")
                                .resizable()
                                .frame(width: 100, height: 100)
                            Spacer(minLength: 20)
                            Text("iWallet")
                                .foregroundColor(.gray).bold()
                                .font(.largeTitle)
                            Spacer(minLength: 50)
                        }
                        Section {
                            HStack {
                                Text(selectedCurrency.symbol)
                                    .foregroundColor(Color("colorBlack"))
                                    .frame(width: 30, height: 30)
                                    .background(Color("colorBrown1"))
                                    .cornerRadius(7.5)
                                Text("Currency")
                                Spacer()
                                Picker("Currency", selection: $selectedCurrency) {
                                    ForEach(Currency.sortedCases, id: \.self) { currency in
                                        Text(currency.rawValue)
                                            .tag(currency)
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color(Colors.colorBalanceBG))
                            .cornerRadius(12.5)
                        } header: {
                            HStack {
                                Text("Initial application setup").font(.caption).fontWeight(.light).padding(.leading).textCase(.uppercase)
                                Spacer()
                            }
                        }
                        
                        HStack {
                            Text(appVM.roundingNumbers ? "0" : "0.0")
                                .foregroundColor(Color("colorBlack"))
                                .frame(width: 30, height: 30)
                                .background(Color(Colors.colorGreen))
                                .cornerRadius(7.5)
                            Toggle("Rounding numbers", isOn: $appVM.roundingNumbers)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(Color(Colors.colorBalanceBG))
                        .cornerRadius(12.5)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Toggle("Basic categories", isOn: $createCategories)
                                    .toggleStyle(SwitchToggleStyle(tint: Color.green))
                            }
                            HStack {
                                Image(systemName: "exclamationmark.shield")
                                Text("Note: Enabling this feature will create base categories for expenses and income.")
                            }
                            .font(.subheadline)
                            .fontWeight(.ultraLight)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .background(Color(Colors.colorBalanceBG))
                        .cornerRadius(12.5)
                    }
                }
                VStack {
                    Button {
                        playFeedbackHaptic(appVM.selectedFeedbackHaptic)
                        appVM.hasRunBefore = true
                        appVM.currencySymbol = selectedCurrency.symbol
                        if createCategories {
                            categoryVM.createDefaultCategories()
                        }
                    } label: {
                        HStack(alignment: .center) {
                            Text("Continue")
                                .frame(maxWidth: .infinity, maxHeight: 20)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white).bold()
                                .cornerRadius(15)
                        }
                    }
                }
            }
            .padding(15)
            .background(Color(Colors.mainBG))
        }
        .onChange(of: selectedCurrency) { newCurrency in
            // Сохраняем символ валюты при изменении выбора
            appVM.currencySymbol = newCurrency.symbol
            playFeedbackHaptic(appVM.selectedFeedbackHaptic)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

