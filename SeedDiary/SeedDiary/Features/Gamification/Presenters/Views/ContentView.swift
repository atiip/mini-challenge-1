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
    //    @StateObject var personalInformationViewModel = PersonalInformationViewModel()
    @EnvironmentObject var userViewModel: PersonalInformationViewModel
    @StateObject var activitiesViewModel: ActivityViewModel = ActivityViewModel()
    @StateObject var goalsViewModel = GoalsViewModel()
    @State private var selectedTab = 0
    @State private var username = ""
    @State private var countActivity: Int = 0
    
    var body: some View {
        VStack(alignment: .center){
            // Content
            switch selectedTab{
            case 1:
                GardenView().environmentObject(userViewModel)
            case 2:
                StatisticView()
                    .environmentObject(userViewModel)
                    .environmentObject(goalsViewModel)
                    .environmentObject(activitiesViewModel)
            default:
                
                ActivitiesView().environmentObject(router)
                    .environmentObject(userViewModel)
                    .environmentObject(goalsViewModel)
                    .environmentObject(activitiesViewModel)
                
                
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
            //                guard let user = userViewModel.getUserByUserId(userId: userViewModel.userId!) else {
            //                    return
            //                }
           
            
        }
        
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Router())
            .environmentObject(PersonalInformationViewModel())
    }
}
