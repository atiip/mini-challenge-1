//
//  AddActivitySheet.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 29/10/23.
//

import SwiftUI

struct AddActivitySheet: View {
    @Environment(\.presentationMode) var presentationMode
    @State var activityTitle = ""
    @State var desc = ""
    @State var startDate_ = Date()
    @State var endDate_ = Date().dayAfter
    
    @State var isLoading = false
    @State var isShowingAlert = false
    
    @EnvironmentObject var activityViewModel: ActivityViewModel
    @EnvironmentObject var goalsViewModel: GoalsViewModel
    @EnvironmentObject var userViewModel: PersonalInformationViewModel

    
    //    @Binding var isAddActivityViewPresented : Bool
//    @State var goalId: UUID
    @State var currentGoalName: String?
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
            VStack{
                VStack{
                    // MARK: TITLE PAGE
                    HStack{
                        Text("New Activity")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                        Spacer()
                    }.padding()
                    
                    HStack{
                        Text(currentGoalName ?? "")
                            .font(.system(size: 18))
                            .foregroundColor(Color("text-color"))
                            .fontWeight(.regular)
                        Spacer()
                    }.padding(EdgeInsets(top: 0, leading: 24, bottom: 12, trailing: 24))
                    
                    Section{
                        // MARK: GOAL FIELD
                        HStack{
                            Text("Activity Title")
                                .font(.system(size: 17))
                                .fontWeight(.bold)
                                .foregroundColor(Color("subtitle-color"))
                            Spacer()
                        }.padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
                        HStack {
                            TextField("Your Activity", text: $activityTitle)
                                .foregroundColor(Color("text-color"))
                                .fontWeight(.bold)
                        }.underlineTextField()
                        
                        Spacer().frame(height:16)
                    }
                    
                    // MARK: DESCRIPTION FIELD
                    Section{
                        HStack{
                            Text("Description")
                                .font(.system(size: 17))
                                .fontWeight(.bold)
                                .foregroundColor(Color("subtitle-color"))
                            Spacer()
                        }.padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
                        HStack {
                            TextField("Add description activity here", text: $desc)
                                .foregroundColor(Color("text-color"))
                                .fontWeight(.bold)
                        }.underlineTextField()
                        Spacer().frame(height:16)
                    }
                    
                    // MARK: START DATEPICKER FIELD
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
                    
                    // MARK: END DATEPICKER FIELD
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
                HStack(){
                    Button {
                        // Add dis later
//                        presentationMode.wrappedValue.dismiss()
                        if (activityTitle.isEmpty || desc.isEmpty) {
                            isShowingAlert = true
                        } else {
                            isLoading = true
                            print("button clicked")
                            if let goalIdUserDefaults = UserDefaults.standard.string(forKey: "goalId"){
                                let goalId = UUID(uuidString: goalIdUserDefaults)
                                guard let user = userViewModel.getUserByUserId(userId: userViewModel.userId!) else {
                                    print("nothing")
                                    return
                                }
                                guard let goalObj = goalsViewModel.getGoal(goalId: goalId!, user: user) else {
                                    return
                                    print("nothing too")
                                }
                             
                                print(goalObj.id ?? "ga ada")
                                activityViewModel.createActivity(goal: goalObj, activityName: activityTitle, desc: desc, startDate: startDate_, endDate: endDate_, status: false)
                            }
                           
              
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                                isLoading = false
                                presentationMode.wrappedValue.dismiss()
                            }
//
                        }
                    } label: {
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
                                            Text("Add New Activities").foregroundColor(.white)
                                        }
                                    }
                                )
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                }
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Notification"), message: Text("Goal and Activity field cannot be empty!"), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear{
            if let goalIdUserDefaults = UserDefaults.standard.string(forKey: "goalId"){
                let goalId = UUID(uuidString: goalIdUserDefaults)
                print("before goal id ")
                print(goalId)
                guard let goalObj = goalsViewModel.getGoal(goalId: goalId!, user: userViewModel.getLatestUser()!) else {
                    return
                }
                currentGoalName = goalObj.goal ?? ""
                print("ini apa")
                print(currentGoalName)
            }

           
            
//            guard let goalObj = goalsViewModel.getGoal(goalId: goalID ?? UUID()) else {
//                return
//            }
//            currentGoal = goalObj.goal ?? ""
//            print("ini apa")
//            print(currentGoal)

        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .navigationBarItems(leading: CustomBackButton()) // Use a custom back button
    }
    
    
}
struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack{
                Image(systemName: "chevron.left")
                    .foregroundColor(Color("text-color"))// Set the color of the back button
                    .imageScale(.large)
                Text("Back")
                    .foregroundColor(Color("text-color"))
                    .fontWeight(.bold)
            }
           
        }
       
    }
}

struct AddActivitySheet_Previews: PreviewProvider {
    static var previews: some View {
        AddActivitySheet()
    }
}
