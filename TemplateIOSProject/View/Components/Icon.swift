//
//  Icon.swift
//  QuickLifts
//
//  Created by Tremaine Grant on 6/27/23.
//

import Foundation

enum Icon {
    case sfSymbol(SFSymbols)
    case custom(String)
}

enum SFSymbols: String {
    case message = "message"
    case pencil = "pencil"
    case person = "person"
    case gear = "gear"
    case check = "checkmark"
}
