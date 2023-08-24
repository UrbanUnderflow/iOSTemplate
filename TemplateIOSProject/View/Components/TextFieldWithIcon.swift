//
//  TextFieldWithIcon.swift
//  QuickLifts
//
//  Created by Tremaine Grant on 6/27/23.
//

import SwiftUI

struct TextFieldWithIcon: View {
    @Binding var text: String
    let placeholder: String
    let iconName: String
    let isSecure: Bool
    @State private var showPassword: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(height: 56)
            
            HStack {
                Spacer()
                Image(iconName)
                    .resizable()
                    .frame(width: 22, height: 22)
                    .padding(.trailing, 5)
                
                if isSecure && !showPassword {
                    SecureField(placeholder, text: $text)
                        .background(.clear)
                        .padding(.leading, 16)
                } else {
                    TextField(placeholder, text: $text)
                        .background(.clear)
                        .padding(.leading, 16)
                }
                
                if isSecure {
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
            }
        }
        .cornerRadius(10)
    }
}

struct TextFieldWithIcon_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithIcon(text: .constant(""), placeholder: "Email address", iconName: "Message", isSecure: false)
    }
}
