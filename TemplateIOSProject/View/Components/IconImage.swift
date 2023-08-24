//
//  IconImage.swift
//  QuickLifts
//
//  Created by Tremaine Grant on 6/27/23.
//

import Foundation
import SwiftUI

struct IconImage: View {
    let icon: Icon
    let color: Color?

    init(_ icon: Icon, color: Color? = nil) {
        self.icon = icon
        self.color = color
    }

    var body: some View {
        Group {
            switch icon {
            case .sfSymbol(let sfSymbol):
                Image(systemName: sfSymbol.rawValue)
                    .foregroundColor(color)
            case .custom(let customIconName):
                Image(customIconName)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}
