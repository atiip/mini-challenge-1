//
//  AddGoalsView.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 05/05/23.
//


import SwiftUI
import CoreData

struct AddGoalsView: View {
    
    @StateObject var goalsViewModel = GoalsViewModel()
    @StateObject var userViewModel = PersonalInformationViewModel()
    
    @State var goal_ = ""
    @State var activity_ = ""
    @State var startDate_ = Date()
    @State var endDate_ = Date().dayAfter
    @State var isShowingAlert = false
    @State var isLoading = false
    
    @Binding var isAddGoalsViewPresented: Bool
    @Binding var isFirstGoals: Bool
    @Binding var addFirstGoalsComplete:Bool
   
//    @AppStorage("userID") var userID: String = UserDe
    
    let status_ = true
    var body: some View {
        
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
                VStack{
                    // MARK: TITLE PAGE
                    HStack{
                        Text("Goals")
                            .font(.system(size: 17))
                            .fontWeight(.bold)
                        Spacer()
                    }.padding()
                    
                    // MARK: GOAL FIELD
                    HStack{
                        Text("Goal")
                            .font(.system(size: 17))
                            .fontWeight(.bold)
                            .foregroundColor(Color("subtitle-color"))
                        Spacer()
                    }.padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
                    HStack {
                        TextField("Your goal", text: $goal_)
                            .foregroundColor(Color("text-color"))
                            .fontWeight(.bold)
                    }.underlineTextField()
                    Spacer().frame(height:16)
                    
//                    // MARK: ACTIVITY FIELD
//                    Section{
//                        HStack{
//                            Text("Activity")
//                                .font(.system(size: 17))
//                                .fontWeight(.bold)
//                                .foregroundColor(Color("text-color"))
//                                .fontWeight(.bold)
//                            Spacer()
//                        }.padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
//                        HStack {
//                            TextField("Your Activity", text: $activity_)
//                                .foregroundColor(Color("subtitle-color"))
//                            
//                        }.underlineTextField()
//                        Spacer().frame(height:16)
//                    }
                    // MARK: DATEPICKER FIELD
                    HStack{
                        Text("Start Date")
                            .font(.system(size: 17))
                            .fontWeight(.bold)
                            .foregroundColor(Color("subtitle-color"))
                        Spacer()
                    }.padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
                    HStack {
                        DatePicker("\(Date().dateString(from: startDate_))", selection: $startDate_, in: Date()..., displayedComponents: .date)
                            .foregroundColor(Color("text-color"))
                            .fontWeight(.bold)
                    }.underlineTextField()
                    Spacer().frame(height:16)
                    
                    // MARK: DATEPICKER FIELD
                    HStack{
                        Text("End Date")
                            .font(.system(size: 17))
                            .fontWeight(.bold)
                            .foregroundColor(Color("subtitle-color"))
                        Spacer()
                    }.padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
                    HStack {
                        DatePicker("\(Date().dateString(from: endDate_))", selection: $endDate_, in: Date().dayAfter..., displayedComponents: .date)
                            .foregroundColor(Color("text-color"))
                            .fontWeight(.bold)
                    }.underlineTextField()
                }
                Spacer()
                
                // MARK: BUTTON
                HStack(){
                    Button {
                        if (goal_.isEmpty) {
                            isShowingAlert = true
                        } else {
                            isLoading = true
                            let idUser = UUID(uuidString: UserDefaults.standard.string(forKey: "userID") ?? "")
                            guard let user = userViewModel.getUserByUserId(userId: idUser ?? UUID()) else {
                                return
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                goalsViewModel.createGoal(user: user, goalName: goal_, startDate: Date().convertDate(date: startDate_), endDate: Date().convertDate(date: endDate_), status: false)
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                addFirstGoalsComplete = true
                                isLoading = false
                                isAddGoalsViewPresented = false
                                
                            }
                            
                        }
                    } label: {
                        if (isFirstGoals) {
                            ZStack {
                                Capsule()
                                    .fill(Color(red: 63/255, green: 120/255, blue: 82/255))
                                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
                                    .frame(width: 350, height: 50)
                                    .overlay(
                                        Group {
                                            if isLoading {
                                                ProgressView()
                                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            } else {
                                                Text("Add Your First Goal").foregroundColor(.white)
                                            }
                                        }
                                    )
                            }
                        }else{
                            ZStack {
                                Capsule()
                                    .fill(Color(red: 63/255, green: 120/255, blue: 82/255))
                                    .shadow(color: .gray, radius: 10, x: 0, y: 5)
                                    .frame(width: 350, height: 50)
                                    .overlay(
                                        Group {
                                            if isLoading {
                                                ProgressView()
                                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            } else {
                                                Text("Add New Goal").foregroundColor(.white)
                                            }
                                        }
                                    )
                            }
                        }
                        
                        
                    }
                    .navigationDestination(isPresented: $addFirstGoalsComplete, destination: {
                        ContentView()
                    })
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                }
                
            }
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Notification"), message: Text("Goal and Activity field cannot be empty!"), dismissButton: .default(Text("OK")))
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

struct AddGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        AddGoalsView(isAddGoalsViewPresented: .constant(false), isFirstGoals: .constant(false), addFirstGoalsComplete: .constant(false))
    }
}
