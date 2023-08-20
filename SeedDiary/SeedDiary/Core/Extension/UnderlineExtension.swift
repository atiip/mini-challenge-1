//
//  UnderlineExtension.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 05/08/23.
//

import SwiftUI

public extension View {
    func underlineTextField() -> some View {
        self
            .padding(.vertical, 8)
            .overlay(Rectangle().frame(height: 2).padding(.top, 45))
            .foregroundColor(.black).opacity(0.5)
            .padding(EdgeInsets(top: 0, leading: 24, bottom: 12, trailing: 24))
    }
}
