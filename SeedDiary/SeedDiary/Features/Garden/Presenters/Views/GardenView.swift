//
//  GardenView.swift
//  SeedDary
//
//  Created by Muhammad Athif on 02/05/23.
//

import SwiftUI
import CoreData

public struct GardenView: View {
    @EnvironmentObject var userViewModel: PersonalInformationViewModel
    //    @StateObject var viewGarden: GardenViewModel
    // TODO: masukin goals view model dan activity view model
    @State var isAddGoalsViewPresented = false
    @State var isAddActivityViewPresented = false
//    let date = Date()
//    @State var totalDistinctGoals: Int = 0
//    @State var isShowingCreateFirstGoal: Bool = false
//    @State var isJournalViewPresented: Bool = false
    @State var isFirstGoals = false
    @State var addFirstGoal = false
    
    public var body: some View {
        ZStack{
            VStack{
                
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity
            )
            .background(Color("bg-color")).opacity(0.5)
            VStack{
                
                // AppBar
                HStack{
                    Text("GARDEN")
                        .fontWeight(.bold)
                    Spacer()
                }.frame(width: UIScreen.main.bounds.width-50)
                
                Spacer()
                ZStack{
                    
                    // TODO: Buat dot kyak figma atau kayak microsoft edge (animasi)
                    // TODO: Bikin logic untuk ganti gambar juga
                    Image("icon-rak-pot-final")
                        .resizable()
                        .frame(width: 360, height: 260)
                }
                
                Spacer()
                
                HStack{
                    Spacer()
                    Menu {
                        Button() {
                            isAddActivityViewPresented = true
                        } label: {
                            Label("Add Activity", systemImage: "list.bullet.clipboard")
                        }
                        Button {
                            isAddGoalsViewPresented = true
                        } label: {
                            Label("Add Goals", systemImage: "pencil")
                        }
                        
                       
                    } label: {
                        VStack{
                            Image(systemName: "plus.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.black)
//                            Text("Add")
//                                .font(.system(size: 12))
//                                .fontWeight(.bold)
//                                .foregroundColor(.black)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 32))
                       

                    
                }
            }
            .sheet(isPresented: $isAddGoalsViewPresented) {
                AddGoalsView(isAddGoalsViewPresented: $isAddGoalsViewPresented, isFirstGoals: $isFirstGoals, addFirstGoalsComplete: $addFirstGoal) .presentationDetents([.height(700)])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $isAddActivityViewPresented) {
              DetailActivitesView(isAddActivityViewPresented: $isAddActivityViewPresented).presentationDragIndicator(.visible).environmentObject(userViewModel)
            }
            
        }
        
    }
    
    
}

struct GardenView_Previews: PreviewProvider {
    static var previews: some View {
        GardenView()
    }
}
