//
//  PotionType.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 11/7/25.
//
import SwiftUI

enum PotionType: Int, CustomStringConvertible, Codable {
    case red
    case purple
    case green
    case yellow
    
    var color: Color {
        switch self {
        case .red:
            return Color.red
        case .purple:
            return Color.cyan
        case .green:
            return Color.green
        case .yellow:
            return Color.yellow
        }
    }
    
    var description: String {
        switch self {
        case .red:
            return "fire"
        case .purple:
            return "ice"
        case .green:
            return "poison"
        case .yellow:
            return "electric"
        }
    }
    
    var rawString: String {
        switch self {
        case .red:
            return "red"
        case .purple:
            return "purple"
        case .green:
            return "green"
        case .yellow:
            return "yellow"
        }
    }
}
