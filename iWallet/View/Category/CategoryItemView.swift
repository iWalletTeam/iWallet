//
//  SwiftUIView.swift
//  iWallet
//
//  Created by Vladislav Novoshinskiy on 26.05.2023.
//

import SwiftUI

struct CategoryItemView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    
    let categoryColor: String
    let categoryIcon: String
    let categoryName: String
    let totalAmount: Float
    let currencySymbol: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HStack {
                    Divider()
                        .foregroundColor(Color(categoryColor))
                        .frame(width: 5, height: 50)
                        .background(Color(categoryColor))
                }
                
                Image(systemName: categoryIcon)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                    .frame(width: 30, height: 30)
                    .background(Color(categoryColor))
                    .cornerRadius(7.5)
                    .padding(0)
                
                Text(categoryName)
                    .font(.headline)
                    .fontWeight(.light)
                    .foregroundColor(Color(Colors.mainText))
                
                Spacer()
                
                Text("\(totalAmount.formattedWithSeparatorAndCurrency(roundingNumbers: appVM.roundingNumbers)) \(currencySymbol)")
                    .font(.headline).bold()
                    .foregroundColor(Color(Colors.mainText))
                
                Image(systemName: "chevron.forward")
                    .foregroundColor(Color(Colors.mainText))
                    .opacity(0.5)
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(Color(Colors.colorBalanceBG))
            
            Divider()
        }
    }
}

struct CategoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryItemView(categoryColor: Colors.colorBlue, categoryIcon: "plus", categoryName: "Food", totalAmount: 100, currencySymbol: "$")
    }
}

