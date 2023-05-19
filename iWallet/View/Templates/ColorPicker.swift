//  SwiftUIView.swift

import SwiftUI

struct ColorPicker: View {
    @Binding var selectedColor: String
    private let colors: [String] =
    [
        "colorBlue", "colorBlue1","colorBlue2", "colorYellow", "colorYellow1", "colorYellow2", "colorGreen", "colorGreen1", "colorGreen2", "colorRed", "colorRed1", "colorRed2", "colorPurple", "colorPurple1", "colorPurple2", "colorBrown", "colorBrown1", "colorBrown2", "colorGray1", "colorGray2", "colorGray"
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center) {
                ForEach(colors, id: \.self) { color in
                    Circle()
                        .foregroundColor(Color(color))
                        .frame(width: 25, height: 25)
                        .opacity(color == selectedColor ? 1.0 : 0.5)
                        .scaleEffect(color == selectedColor ? 1.1 : 1.0)
                        .onTapGesture {
                            selectedColor = color
                        }
                }
            } .padding()
        }
    }
}

struct ColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorPicker(selectedColor: .constant("colorBlue"))
    }
}
