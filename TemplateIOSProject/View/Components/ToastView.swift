//
//  ToastView.swift
//  QuickLifts
//
//  Created by Tremaine Grant on 6/27/23.
//

import SwiftUI

struct ToastView: View {
    let message: String
    let backgroundColor: Color
    let textColor: Color
    let icon: Icon?

    init(message: String, backgroundColor: Color, textColor: Color, icon: Icon? = nil) {
        self.message = message
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.icon = icon
    }

    var body: some View {
        HStack {
            if let icon = icon {
                IconImage(icon, color: textColor)
            }
            Text(message)
                .padding()
                .background(backgroundColor)
                .foregroundColor(textColor)
                .cornerRadius(8)
        }
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(message: "Hello", backgroundColor: .secondaryBlue, textColor: .secondaryWhite)
    }
}
