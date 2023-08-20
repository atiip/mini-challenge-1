//
//  AppColors.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 30/07/23.
//

import Foundation
import SwiftUI


import Foundation
import SwiftUI

// Dummy file
struct AppColors {
    static let red = Color(.red)
    static let borderColor =  Color(UIColor(hex: "C6C6C8"))
    static let primary100 = Color(UIColor(hex: "5856D6"))
    static let secondaryText = Color(UIColor(hex: "3C3C43"))
    static let secondary = Color(UIColor.secondarySystemBackground)
    static let homeBgColor = Color(UIColor(hex: "EFEFF4"))
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        self.init(
            red: Double((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: Double((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}
