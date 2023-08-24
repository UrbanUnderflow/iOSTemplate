//
//  ConfirmationButton.swift
//  QuickLifts
//
//  Created by Tremaine Grant on 6/27/23.
//

import SwiftUI

enum ButtonType: String {
    case primaryBlue
    case secondaryWhite
    case secondaryBlue
    case primaryLargeConfirmation
    case secondaryLargeConfirmation
    case clearButton
}

struct ConfirmationButton: View {
    var title: String
    var type: ButtonType
    var action: () -> ()
    
    var body: some View {
        switch type {
        case .primaryBlue:
            Button(action: action) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.secondaryWhite)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(Color.primaryBlue)
                    .cornerRadius(50)
            }
        case .secondaryWhite:
            Button(action: action) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.secondaryBlue)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(Color.secondaryWhite)
                    .cornerRadius(50)
            }
        case .secondaryBlue:
            Button(action: action) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.secondaryWhite)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(Color.secondaryBlue)
                    .cornerRadius(50)
            }
        case .primaryLargeConfirmation:
            Button(action: action) {
                Text(title)
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.primaryBlue)
                    .cornerRadius(50)
            }
        case .secondaryLargeConfirmation:
            Button(action: action) {
                Text(title)
                    .font(.title2)
                    .foregroundColor(Color.secondaryWhite)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.secondaryBlue)
                    .cornerRadius(50)
            }
        case .clearButton:
            Button(action: action) {
                Text(title)
                    .font(.title2)
                    .foregroundColor(Color.secondaryWhite)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(50)
            }
        }
    }
}

struct ConfirmationButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ConfirmationButton(title: "test", type: .secondaryBlue) {
                print("aciton")
            }
            ConfirmationButton(title: "test", type: .clearButton) {
                print("aciton")
            }
        }
        
    }
}
