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
    @State private var isFirstLogin = true
    @State private var isOpening = false
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
                if isOpening{
                    OpeningView()
                        .environmentObject(router)
                        .environmentObject(userViewModel)
                }else{
                    ContentView()
                        .environmentObject(router)
                        .environmentObject(userViewModel)
                }
            }
            .onAppear{
                if isFirstLogin == true {
                    isOpening = true
                }else{
                    isOpening = false
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
