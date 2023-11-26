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

enum Route: Hashable {
    case openingView
    case activitiesview
    case gardenView
    case statisticView
    case addFirstGoalView
    

    var viewToShow: some View {
        switch self {
        case .openingView:
            return AnyView(OpeningView())
        case .activitiesview:
            return AnyView(EmptyView())
        case .gardenView:
            return AnyView(EmptyView())
        case .addFirstGoalView:
            return AnyView(EmptyView())
        case .statisticView:
            return AnyView(EmptyView())
        }
    }
}
