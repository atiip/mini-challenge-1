//
//  Router.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 30/07/23.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    func reset(){
        path = NavigationPath()
    }
}
