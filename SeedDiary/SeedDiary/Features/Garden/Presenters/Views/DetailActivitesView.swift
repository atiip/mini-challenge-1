//
//  DetailActivitesView.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 05/05/23.
//


import SwiftUI

struct DetailActivitesView: View {
    @EnvironmentObject var userViewModel: PersonalInformationViewModel
    @StateObject var goalsViewModel = GoalsViewModel()
    @StateObject var activitiesViewModel = ActivityViewModel()
    //    @StateObject var userViewModel = PersonalInformationViewModel()
    
    let talk: String = "Don’t worry this will be our little secret"
    @State var finalText: String = ""
    
    //    @State private var isSheetActivityActive = false
    //    @State var isFlag = false
    //    @State private var shouldRefresh = false
    
    @State private var selectedGoal: UUID? = nil
    
    @State private var goalsName : [String] = []
    
    @State private var selectedColor = "Red"
    let colors = ["Red", "Green", "Blue"]
    
    //    @State var currentGoal: Goal? = nil
    @AppStorage("goalId") var goalId: String = ""
    @AppStorage("goalName") var goalName: String = ""
    
    @Binding var isAddActivityViewPresented : Bool
    
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
                                
                                guard let user = userViewModel.getUserByUserId(userId: userViewModel.userId! ) else {
                                    return
                                    print("ga ada user")
                                }
                                guard let goalObj = goalsViewModel.getGoal(goalId: selectedGoal, user: user) else {
                                    return
                                }
                                UserDefaults.standard.set(goalObj.goal, forKey: "goalName")
                     
//                                print(goalObj.goal ?? "")
                            }
                        })
                        .disabled(selectedGoal != nil ? false : true)
                        //                    Button{
                        //                        isAddSheetActivity = true
                        //                    } label:{
                        //                        VStack{
                        //                            Image(systemName: "plus.circle")
                        //                                .resizable()
                        //                                .scaledToFit()
                        //                                .frame(width: 25, height: 25)
                        //                                .foregroundColor(.black)
                        //                            Text("Add Activity")
                        //                                .font(.system(size: 12))
                        //                                .fontWeight(.bold)
                        //                                .foregroundColor(.black)
                        //                        }
                        //                    }
                        //                    .sheet(isPresented: $isAddSheetActivity) {
                        //                        AddActivitySheet(isAddSheetActivity: $isAddSheetActivity).presentationDragIndicator(.visible)
                        //                    }
                        
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
                            
                            // TODO: Buatlah dropdown goal apa saja yang telah dibuat
                            
                            Picker("Select Goal", selection: $selectedGoal) {
                                // Tambahkan pilihan default atau placeholder jika goalsName kosong
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
                                print("ubah")
                                if let selectedGoal = newValue {
                                    // Call the getActivitiesByGoal method with the selected goal
                                    if let goal = goalsViewModel.getGoal(goalId: selectedGoal, user: userViewModel.getUserByUserId(userId: userViewModel.userId!)!) {
                                        activitiesViewModel.getActivitiesByGoal(forGoal: goal)
                                    }
                                }else if selectedGoal == nil {
                                    activitiesViewModel.filteredActivityByGoal = []
                                }
                            })                            .pickerStyle(.menu)
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
                            // TODO: Fetch data activity setiap goals here using for each
                            ForEach(activitiesViewModel.filteredActivityByGoal, id: \.id) {activity in
                                Group{
                                    HStack{
                                        Text("\(activity.activityName ?? " ")")
                                            .font(.system(size: 14))
                                            .fontWeight(.regular)
                                        
                                        Spacer()
                                        // TODO: Disini tinggal dibikin (\(dateString(from: startDate) - \(dateString(from: endDate)
                                        // contoh fetch ada diatas, jangan lupa bikin func untuk ngedapetin hari dan bulan doang contohnya ada di addGoalviewmodel
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
                guard let user = userViewModel.getUserByUserId(userId: userViewModel.userId!) else {
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
