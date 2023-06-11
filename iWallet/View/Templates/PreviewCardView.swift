//  PreviewCardView.swift

import SwiftUI

@ViewBuilder
func previewHomeTransaction() -> some View {
    VStack {
        VStack(alignment: .center) {
            Spacer(minLength: 20)
            Image("icon")
                .resizable()
                .frame(width: 25, height: 25)
            Spacer()
            Text("iWallet")
                .foregroundColor(.gray).bold()
                .font(.title)
            Spacer(minLength: 20)
            
            Text("The list of transactions is currently empty,")
                .foregroundColor(.gray)
                .font(.system(size: 12))
            Text("please add transaction.")
                .foregroundColor(.gray)
                .font(.system(size: 12))
            Spacer(minLength: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
        .background(Color(Colors.colorBalanceBG))
    }
}

@ViewBuilder
func previewCardTransaction() -> some View {
    VStack {
        VStack(alignment: .center) {
            Spacer(minLength: 20)
            Image("icon")
                .resizable()
                .frame(width: 25, height: 25)
            Spacer()
            Text("iWallet")
                .foregroundColor(.gray).bold()
                .font(.title)
            Spacer(minLength: 20)
            
            Text("The list of transactions is currently empty,")
                .foregroundColor(.gray)
                .font(.system(size: 12))
            Text("please add transaction.")
                .foregroundColor(.gray)
                .font(.system(size: 12))
            Spacer(minLength: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
    }
}

@ViewBuilder
func previewCardCategory() -> some View {
    VStack {
        VStack(alignment: .center) {
            Spacer(minLength: 20)
            Image("icon")
                .resizable()
                .frame(width: 25, height: 25)
            Spacer()
            Text("iWallet")
                .foregroundColor(.gray).bold()
                .font(.title)
            Spacer(minLength: 20)
            
            Text("The list of categories is currently empty,")
                .foregroundColor(.gray)
                .font(.system(size: 12))
            Text("please add category.")
                .foregroundColor(.gray)
                .font(.system(size: 12))
            Spacer(minLength: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
    }
}

func previewNoCategory() -> some View {
    VStack {
        VStack(alignment: .center) {
            Spacer(minLength: 20)
            Image("icon")
                .resizable()
                .frame(width: 25, height: 25)
            Spacer()
            Text("iWallet")
                .foregroundColor(.gray).bold()
                .font(.title)
            Spacer(minLength: 20)
            
            Text("There are currently no categories.")
                .foregroundColor(.gray)
                .font(.system(size: 12))
            Text("Please add.")
                .foregroundColor(.gray)
                .font(.system(size: 12))
            Spacer(minLength: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
        .background(Color(Colors.colorBalanceBG))
    }
}
