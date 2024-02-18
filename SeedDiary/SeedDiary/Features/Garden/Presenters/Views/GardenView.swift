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
    @StateObject var goalsViewModel = GoalsViewModel()
    @State var isAddGoalsViewPresented = false
    @State var isAddActivityViewPresented = false
    @State var isDetailGoalViewPresented = false
    @State var isFirstGoals = false
    @State var addFirstGoal = false
    @State var isUpdateGoal = false
    
    let positions = [
            CGPoint(x: 107.0, y: 235.0),
            CGPoint(x: 180.0, y: 235.0),
            CGPoint(x: 170.0, y: 299.0),
            CGPoint(x: 235.0, y: 299.0),
            CGPoint(x: 228.0, y: 351.0),
            CGPoint(x: 290.0, y: 351.0)
        ]
    
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
                    Image("icon-rak-pot-final")
                        .resizable()
                        .frame(width: 360, height: 260)
                    
                    ForEach(Array(goalsViewModel.filteredGoalsByUser.enumerated()), id: \.element) { index, goal in
                            PulsateAnimation(action: {
                                // Action when tapped
                                isDetailGoalViewPresented.toggle()
                            })
                            .position(self.positionForGoal(at: index))
                        }
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
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 32))
                       

                    
                }
            }
            .sheet(isPresented: $isAddGoalsViewPresented) {
                AddGoalsView(isAddGoalsViewPresented: $isAddGoalsViewPresented, isFirstGoals: $isFirstGoals, addFirstGoalsComplete: $addFirstGoal, isUpdateGoal: $isUpdateGoal)
                    .environmentObject(userViewModel)
                    .presentationDetents([.height(700)])
                    .presentationDragIndicator(.visible)
                   
            }
            .sheet(isPresented: $isAddActivityViewPresented) {
              DetailActivitesView(isAddActivityViewPresented: $isAddActivityViewPresented)
                    .environmentObject(goalsViewModel)
                    .environmentObject(userViewModel)
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $isDetailGoalViewPresented) {
              DetailGoalsView(isDetailGoalViewPresented: $isDetailGoalViewPresented)
                    .environmentObject(goalsViewModel)
                    .environmentObject(userViewModel)
                    .presentationDragIndicator(.visible)
            }
            
            
        }
        .onChange(of: isUpdateGoal) { newValue in
            if newValue {
                let idUser = UUID(uuidString: UserDefaults.standard.string(forKey: "userID") ?? "")
                 
                if let user = userViewModel.getUserByUserId(userId: idUser ?? UUID())  {
                    goalsViewModel.getGoalsByUser(forPersonalInformation: user)
                    isUpdateGoal = false
                }
                isUpdateGoal = false
                
            }
        }
        .onAppear {
            let idUser = UUID(uuidString: UserDefaults.standard.string(forKey: "userID") ?? "")
             
            if let user = userViewModel.getUserByUserId(userId: idUser ?? UUID())  {
                goalsViewModel.getGoalsByUser(forPersonalInformation: user)
            }
        }
        
    }
    func positionForGoal(at index: Int) -> CGPoint {
           return positions[min(index, positions.count - 1)]
       }
    
    
}

struct GardenView_Previews: PreviewProvider {
    static var previews: some View {
        GardenView()
    }
}
