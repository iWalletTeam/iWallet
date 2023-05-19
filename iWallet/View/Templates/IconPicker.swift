//  SFIconPicker.swift

import SwiftUI

struct IconPicker: View {
    @Binding var selectedImage: String
    private let images: [String] =
    [
        "car", "box.truck", "car.2", "creditcard", "banknote", "giftcard", "person.2", "person.bust", "figure.wave", "figure.roll", "circle.hexagonpath", "captions.bubble", "network.badge.shield.half.filled", "icloud", "bonjour", "figure.2.and.child.holdinghands", "figure.and.child.holdinghands", "face.smiling", "house", "sofa", "fireplace", "fish", "hare", "pawprint", "popcorn", "balloon.2", "figure.walk", "heart", "pill", "cross", "fleuron", "wand.and.stars.inverse", "pencil.tip", "wifi", "antenna.radiowaves.left.and.right", "network", "book", "graduationcap", "pencil.and.ruler", "backpack", "tshirt", "tag", "gift", "shippingbox", "party.popper.fill", "cart", "carrot", "airpods.chargingcase", "airplane", "sailboat", "road.lanes", "music.mic", "theatermasks", "birthday.cake", "display", "applewatch.watchface", "gamecontroller", "bus.fill", "cablecar", "steeringwheel", "key", "door.right.hand.closed", "house.and.flag", "arrow.triangle.2.circlepath", "dollarsign.arrow.circlepath", "hourglass", "chart.xyaxis.line", "creditcard.and.123", "chart.bar", "dollarsign", "rublesign", "eurosign", "shippingbox.circle", "timelapse", "camera.metering.matrix", "person.fill.checkmark", "person.crop.square.filled.and.at.rectangle.fill", "hand.thumbsup", "percent", "sum", "number"
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center) {
                ForEach(images, id: \.self) { image in
                    HStack {
                        VStack {
                            Image(systemName: image)
                                .foregroundColor(Color("colorBalanceText"))
                                .font(.system(size: 30))
                        }
                    }
                    .opacity(image == selectedImage ? 1.0 : 0.5)
                    .scaleEffect(image == selectedImage ? 1.1 : 1.0)
                    .onTapGesture {
                        selectedImage = image
                    }
                }
            } .padding(.vertical, 5)
        }
    }
}

struct IconPicker_Previews: PreviewProvider {
    static var previews: some View {
        IconPicker(selectedImage: .constant("folder.circle"))
    }
}
