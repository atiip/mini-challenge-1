//
//  CircleModel.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 29/07/23.
//

import Foundation
import SwiftUI
struct CircleModel: Identifiable,Equatable{
    var id = UUID().uuidString
    var position: CGPoint
    var size: CGFloat = 0
    
    init(id: String = UUID().uuidString, position: CGPoint, size: CGFloat) {
        self.id = id
        self.position = position
        self.size = size
    }
}
