//
//  ContentView.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 27/07/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var router: Router
    @StateObject var personalInformationViewModel = PersonalInformationViewModel()
    @State private var selectedTab = 0
    var body: some View {
      
            VStack(alignment: .center){
                // Content
                
                switch selectedTab{
                case 1:
                    GardenView()
                case 2:
                    StatisticView()
                default:
                    var totalActivity: Int = 5
                    var pola = Variation(jumlah: totalActivity).variasi
                    ActivitiesView(pola: pola).environmentObject(router)
                }
                // Bottom app bar
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 63/255, green: 120/255, blue: 82/255))
                        .frame(width: 400, height: 80)
                    HStack{
                        Spacer()
                        
                        Button{
                            selectedTab = 0
                        } label:{
                            Image("icon-activities")
                                .resizable()
                                .frame(width: 15, height: 25)
                            Text("Activities")
                                .foregroundColor(.white)
                                .opacity(selectedTab == 0 ? 1 : 0.5)
                        }
                        Spacer()
                        Button{
                            selectedTab = 1
                        } label:{
                            Image("icon-garden")
                                .resizable()
                                .frame(width: 15, height: 25)
                            Text("Garden")
                                .foregroundColor(.white)
                                .opacity(selectedTab == 1 ? 1 : 0.5)
                        }
                        Spacer()
                        Button{
                            selectedTab = 2
                        } label:{
                            Image("icon-statistic")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Statistic")
                                .foregroundColor(.white)
                                .opacity(selectedTab == 2 ? 1 : 0.5)
                        }
                        Spacer()
                    }
                }
               
            }
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.bottom)
            .onAppear{
                personalInformationViewModel.getName()
            }
      
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Router())
    }
}
