//
//  DetailGoalsView.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 19/02/24.
//

import SwiftUI

struct DetailGoalsView: View {
    
    @EnvironmentObject var userViewModel: PersonalInformationViewModel
    @EnvironmentObject var goalsViewModel: GoalsViewModel
    @StateObject var activitiesViewModel = ActivityViewModel()
    
    let talk: String = "Let's see, how much progress have you made"
    @State var finalText: String = ""
    
    @AppStorage("goalId") var goalId: String = ""
    @AppStorage("goalName") var goalName: String = ""
    
    @Binding var isDetailGoalViewPresented : Bool
    
    @State var goal_: Goal?
    
    var body: some View {
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
                        Text("Detail Goal")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 24)
                    .padding(.horizontal, 16)
                   
                    
                    // TODO: Fetch buat list Activitynya
                    VStack{
                        HStack(alignment: .firstTextBaseline, spacing: 8){
                            Text("Goal name:")
                                .font(.system(size: 17))
                                .fontWeight(.bold)
                            if let goal_ {
                                Text(goal_.goal ?? "")
                                    .font(.system(size: 17))
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                       
                        HStack{
                            Text("Activity ")
                                .font(.system(size: 17))
                                .fontWeight(.bold)
                            Spacer()
                            Text("Status ")
                                .font(.system(size: 17))
                                .fontWeight(.bold)
                        }
                            .padding()
                        ScrollView{
                            // TODO: Fetch data activity setiap goals here using for each
                            ForEach(activitiesViewModel.filteredActivityByGoal, id: \.id) {activity in
                                Group{
                                    HStack{
                                        VStack (alignment: .leading, spacing: 8){
                                            Text("\(activity.activityName ?? " ")")
                                                .font(.system(size: 14))
                                                .fontWeight(.regular)
                                                .multilineTextAlignment(.leading)
                                            
                                            HStack (spacing: 8){
                                                Text("Deadline: ")
                                                    .font(.system(size: 14))
                                                    .fontWeight(.regular)
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
                                            }
                                           
                                            
//
                                        }
                                       
                                        Spacer()
                                        if activity.status == true {
                                            Text("Completed")
                                                .font(.system(size: 14))
                                                .fontWeight(.regular)
                                        }else{
                                            Text("Not completed")
                                                .font(.system(size: 14))
                                                .fontWeight(.regular)
                                        }
                                       

                                    }
                                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                              
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
                if let goalIdUserDefaults = UserDefaults.standard.string(forKey: "goalId"){
                    let goalId = UUID(uuidString: goalIdUserDefaults)
                    let idUser = UUID(uuidString: UserDefaults.standard.string(forKey: "userID") ?? "")
                    guard let user = userViewModel.getUserByUserId(userId: idUser ?? UUID()) else {
                        return
                    }
                    
                    if let goalObj = goalsViewModel.getGoal(goalId: goalId!, user: user) {
                        self.goal_ = goalObj
                        activitiesViewModel.getActivitiesByGoal(forGoal: goalObj)
                    }
                }

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
extension Date {
    static let dateFormatterWithYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
    
    func formattedStringYear() -> String {
        return Date.dateFormatterWithYear.string(from: self)
    }
}
#Preview {
    DetailGoalsView(isDetailGoalViewPresented: .constant(false))

}
