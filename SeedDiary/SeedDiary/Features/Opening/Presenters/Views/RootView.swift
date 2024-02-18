//
//  RootView.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 01/08/23.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var userViewModel: PersonalInformationViewModel
    @EnvironmentObject var goalViewModel: GoalsViewModel
    @State private var isFirstLogin = true
    @State private var isOpening = false
    
    @AppStorage("firstLogin") private var firstLogin:Bool = false
    @AppStorage("isOpeningCompleted") private var isOpeningCompleted = false
//    if (UserDefaults.standard.bool(forKey: "isPage"))
    
    var body: some View {
        NavigationStack(path: $router.path){
            ZStack{
                VStack{
                    
                }
                .ignoresSafeArea()
                .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight:0,
                maxHeight: .infinity
                )
                .background(Color.white)
                if !(UserDefaults.standard.bool(forKey: "isOpeningCompleted")) {
                    OpeningView()
                        .environmentObject(router)
                        .environmentObject(userViewModel)
                        .environmentObject(goalViewModel)
                }else{
                    ContentView()
                        .environmentObject(router)
                        .environmentObject(userViewModel)
                        .environmentObject(goalViewModel)
                }
            }
            .onAppear{
                
                if (UserDefaults.standard.bool(forKey: "firstLogin")) == true {
                    
                    isOpeningCompleted = true
                }else{
                    isOpeningCompleted = false
                }
            }
        }
      
        
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(Router())
    }
}
