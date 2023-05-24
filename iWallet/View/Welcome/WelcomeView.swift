//  WelcomeView.swift

import SwiftUI
import RealmSwift

struct WelcomeView: View {
    @EnvironmentObject var viewModel: SceneViewModel
    
    @AppStorage("hasRunBefore") private var hasRunBefore = false
    @AppStorage("currencySymbol") private var currencySymbol: String = "USD"
    @AppStorage("playFeedbackHaptic") private var selectedFeedbackHaptic: Bool = true
    
    @State private var selectedCurrency: Currency = .usd
    @State private var vibrateOnSilent: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center) {
                        
                        VStack {
                            Spacer(minLength: 50)
                            Image("icon")
                                .resizable()
                                .frame(width: 100, height: 100)
                            Spacer(minLength: 50)
                            Text("Welcome to the iWallet!")
                                .foregroundColor(.gray).bold()
                                .font(.title2)
                            Spacer(minLength: 50)
                        }
                        
                        Section {
                            HStack {
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
                            .background(Color("colorBalanceBG"))
                            .cornerRadius(12.5)
                        } header: {
                            HStack {
                                Text("Initial application setup").font(.caption).fontWeight(.light).padding(.leading).textCase(.uppercase)
                                Spacer()
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Toggle("Basic categories", isOn: $vibrateOnSilent)
                                    .toggleStyle(SwitchToggleStyle(tint: Color("colorGreen")))
                            }
                            Text("Note: Enabling this feature will create base categories for expenses and income.")
                                .font(.subheadline)
                                .fontWeight(.ultraLight)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .background(Color("colorBalanceBG"))
                        .cornerRadius(12.5)
                    }
                }
                
                VStack {
                    Button {
                        playFeedbackHaptic(selectedFeedbackHaptic)
                        hasRunBefore = true
                        currencySymbol = selectedCurrency.symbol
                        if vibrateOnSilent {
                            viewModel.createDefaultCategories()
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
            .background(Color("colorBG"))
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

