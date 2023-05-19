//  PreviewCard.swift

import SwiftUI

func previewCard() -> some View {
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
            Text("Welcome")
                .foregroundColor(.gray)
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
