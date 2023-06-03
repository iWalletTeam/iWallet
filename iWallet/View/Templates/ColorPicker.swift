//  SwiftUIView.swift

import SwiftUI

struct ColorPicker: View {
    @Binding var selectedColor: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center) {
                ForEach(Colors.allColors, id: \.self) { color in
                    Circle()
                        .foregroundColor(Color(color))
                        .frame(width: 25, height: 25)
                        .opacity(color == selectedColor ? 1.0 : 0.5)
                        .scaleEffect(color == selectedColor ? 1.1 : 1.0)
                        .onTapGesture {
                            selectedColor = color
                        }
                }
            }
            .padding()
        }
    }
}

struct ColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorPicker(selectedColor: .constant("colorBlue"))
    }
}
