//  IconPickerView.swift

import SwiftUI

struct IconPickerView: View {
    @Binding var selectedImage: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center) {
                ForEach(Icons.allIcons, id: \.self) { image in
                    HStack {
                        VStack {
                            Image(systemName: image)
                                .foregroundColor(Color(Colors.mainText))
                                .font(.system(size: 20))
                                .frame(width: 40, height: 40)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style: .circular)
                                        .strokeBorder(Color(Colors.mainText))
                                }
                        }
                    }
                    .opacity(image == selectedImage ? 1.0 : 0.5)
                    .scaleEffect(image == selectedImage ? 1.1 : 1.0)
                    .onTapGesture {
                        selectedImage = image
                    }
                }
            }
            .padding(2)
        }
    }
}

struct IconPickerView_Previews: PreviewProvider {
    static var previews: some View {
        IconPickerView(selectedImage: .constant("folder.circle"))
    }
}
