//
//  SeedDiaryApp.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 27/07/23.
//

import SwiftUI
import Inject
//import LocalPackage

@main
struct SeedDiaryApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var router = Router()
    @StateObject private var userViewModel = PersonalInformationViewModel()
    
    

    var body: some Scene {
        WindowGroup {
                    RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(router)
                .environmentObject(userViewModel)
               
        }
    }
}
