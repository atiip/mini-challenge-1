//
//  DetailActivitesView.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 05/05/23.
//


import SwiftUI

struct DetailActivitesView: View {
    @EnvironmentObject var userViewModel: PersonalInformationViewModel
    @EnvironmentObject var goalsViewModel: GoalsViewModel
    @StateObject var activitiesViewModel = ActivityViewModel()
    
    let talk: String = "Don’t worry this will be our little secret"
    @State var finalText: String = ""
    @State private var selectedGoal: UUID? = nil
    @State private var goalsName : [String] = []
    @State private var selectedColor = "Red"
    let colors = ["Red", "Green", "Blue"]
    
    @AppStorage("goalId") var goalId: String = ""
    @AppStorage("goalName") var goalName: String = ""
    
    @Binding var isAddActivityViewPresented : Bool
    
    @State var addFirstGoalsComplete = false
    
    public var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    
                }.frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity
                )
                .background(Color("bg-color")).opacity(0.5)
                
                VStack {
                    HStack{
                        // TODO: Tambahin \(nama var) yang dibawa dari view History card untuk diambil namanya
                        Spacer()
                        Button{
                            
                        } label: {
                            NavigationLink(destination:
                                            AddActivitySheet()
                                            .environmentObject(activitiesViewModel).environmentObject(goalsViewModel)
                                            .environmentObject(userViewModel)
                                           
                            ){
                                VStack{
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(selectedGoal != nil ? .black : .gray)
                                    Text("Add Activity")
                                        .font(.system(size: 12))
                                        .fontWeight(.bold)
                                        .foregroundColor(selectedGoal != nil ? .black : .gray)
                                }
                            }
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            if let selectedGoal = selectedGoal {
                                let selectedGoalId = selectedGoal.uuidString
                                UserDefaults.standard.set(selectedGoalId, forKey: "goalId")
                                
                                let idUser = UUID(uuidString: UserDefaults.standard.string(forKey: "userID") ?? "")
                                guard let user = userViewModel.getUserByUserId(userId: idUser ?? UUID()) else {
                                    return
                                }
                                
                                guard let goalObj = goalsViewModel.getGoal(goalId: selectedGoal, user: user) else {
                                    return
                                }
                                UserDefaults.standard.set(goalObj.goal, forKey: "goalName")
                     

                            }
                        })
                        .disabled(selectedGoal != nil ? false : true)
                    }.padding()
                    
                    // Content Here
                    // TODO: Fetch buat list Activitynya
                    VStack{
                        HStack{
                            Text("Goal ")
                                .font(.system(size: 17))
                                .fontWeight(.bold)
                            Spacer()
                        }.padding()
                        HStack{
                            Picker("Select Goal", selection: $selectedGoal) {
                                Text("Select Goal").tag(nil as UUID?)
                                    .font(.system(size: 14))
                                    .fontWeight(.regular)
                                
                                ForEach(goalsViewModel.filteredGoalsByUser, id: \.id) { goal in
                                    if let goalId = goal.id {
                                        Text(goal.goal!).tag(goalId as UUID?)
                                            .font(.system(size: 14))
                                            .fontWeight(.regular)
                                    } else {
                                        Text("Unknown Goal").tag(nil as UUID?)
                                    }
                                }
                            }
                            .onChange(of: selectedGoal, perform: { newValue in
                                
                                if let selectedGoal = newValue {
                                    let idUser = UUID(uuidString: UserDefaults.standard.string(forKey: "userID") ?? "")
                                    
                                    guard let user = userViewModel.getUserByUserId(userId: idUser ?? UUID()) else {
                                        return
                                    }
                                    if let goal = goalsViewModel.getGoal(goalId: selectedGoal, user: user) {
                                        activitiesViewModel.getActivitiesByGoal(forGoal: goal)
                                    }
                                }else if selectedGoal == nil {
                                    activitiesViewModel.filteredActivityByGoal = []
                                }
                            })                            
                            .pickerStyle(.menu)
                            .tint(Color.black)
                            
                            Spacer()
                        }.padding()
                        HStack{
                            Text("Activity ")
                                .font(.system(size: 17))
                                .fontWeight(.bold)
                            Spacer()
                            Text("Date ")
                                .font(.system(size: 17))
                                .fontWeight(.bold)
                        }.padding()
                        ScrollView{
                            ForEach(activitiesViewModel.filteredActivityByGoal, id: \.id) {activity in
                                Group{
                                    HStack{
                                        Text("\(activity.activityName ?? " ")")
                                            .font(.system(size: 14))
                                            .fontWeight(.regular)
                                        
                                        Spacer()
                                        if let startDate = activity.startDate, let endDate = activity.endDate {
                                            let formattedStartDate = Date.dateFormatter.string(from: startDate)
                                            let formattedEndDate = Date.dateFormatter.string(from: endDate)
                                            Text("\(formattedStartDate) - \(formattedEndDate) ")
                                                .font(.system(size: 14))
                                                .fontWeight(.regular)
                                        } else {
                                            Text("-")
                                                .font(.system(size: 14))
                                                .fontWeight(.regular)
                                        }
                                    }.padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                                }
                            }
                        }
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        VStack{
                            ZStack(alignment: .topLeading){
                                Image("rengtangle-shape")
                                    .resizable()
                                
                                Text(finalText).padding()
                                    .onAppear {
                                        self.typeWriter()
                                        
                                    }
                                
                            }
                            .frame(width: 160, height: 120)
                            Image("icon-potty-happy")
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                    }.padding()
                }
            }
            .onAppear{
                let idUser = UUID(uuidString: UserDefaults.standard.string(forKey: "userID") ?? "")
                guard let user = userViewModel.getUserByUserId(userId: idUser ?? UUID()) else {
                    return
                }
                goalsViewModel.getGoalsByUser(forPersonalInformation: user)
            }
        }
        
    }
    
    func typeWriter(at position: Int = 0) -> Void {
        if position == 0 {
            finalText = ""
        }
        if position < talk.count {
            let index = talk.index(talk.startIndex, offsetBy: position)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                finalText.append(talk[index])
                typeWriter(at: position + 1)
            }
        }
    }
}

struct DetailActivitesView_Previews: PreviewProvider {
    static var previews: some View {
        DetailActivitesView(isAddActivityViewPresented: .constant(false))
    }
}
