//
//  ActivitiesView.swift
//  SeedDary
//
//  Created by Muhammad Athif on 02/05/23.
//


import SwiftUI
import CoreData

struct ActivitiesView: View {
    @State var quotes : [String] = [
        "What a happy day today",
        "Find Happiness Today",
        "Lets Process Our Day"
    ]
    @StateObject var journalsViewModel: JournalsViewModel = JournalsViewModel()
    @StateObject var moodsViewModel: MoodsViewModel = MoodsViewModel()
    @EnvironmentObject var activitiesViewModel: ActivityViewModel
    @EnvironmentObject var userViewModel: PersonalInformationViewModel
    @EnvironmentObject var goalsViewModel: GoalsViewModel
    
    @State private var mood = ""
    @State private var isTaskActive = true
    
    @State private var color = Color.blue
    
    @State var checkJournal = false
    @State var checkOnTap = false
    
    @State var isExploded = false
    @State var isOpacity = false
    
    @State private var showJournal = true
    @State private var showDailyMood = true
    
    private let explodingBits: Int = 15
    let screenSize = UIScreen.main.bounds.size
    
    // Rumus get activity + 2
    @State var totalActivity:Int = 3
    @State private var scale = 1.0
    @State var pola: CircleVariationModel = Variation(jumlah: 2).variasi
    @State var listDataGoal: [Goal] = []
    @State var listDataActivity: [Activity] = []
    @State var listJournal: [Journal] = []
    @State var listDailyMoods: [Mood] = []
    @State var listActivityTrue: [Goal] = []
    @State var listAllActivity: [Goal] = []
    @State var isSheetMoodActive = false
    @State var updated = false
    @State var isSubmitDailyMood: Bool = false
    @State var goalName:String =  ""
    
    public func convertDate(date: Date) -> Date {
        let calender = Calendar.current
        let startOfDay = calender.startOfDay(for: date)
        return startOfDay
    }
    @State var progress: CGFloat = 0
    @State var containerWidth:CGFloat = 0
    
    @State var totalActivityProgress = 3
    @State var stepDone = 0
    @State var statusProgress: Double = 0
    @State var progressBarActive = false
    @State var actName = ""
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack{
            VStack{
                // AppBar
                HStack{
                    Text(Date(), style: .date)
                    Spacer()
                    Button{
                    } label:{
                        Image("icon-achievement")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                }.frame(width: UIScreen.main.bounds.width-50)
                Spacer()
                
                VStack(alignment: .center){
                    
                    if (isTaskActive){
                       
                        HStack{
                            ZStack(alignment: .leading){
                                Capsule()
                                    .fill(Color("bg-progress-bar"))
                                    .frame(width: 250, height: 25)
                                    .shadow(color: Color("shadow-color").opacity(0.2), radius: 2, x: 0, y: 5)
                                    .onAppear{
                                        containerWidth = 250
                                    }
                                
                                Capsule()
                                    .fill(Color("progress-fill-color"))
                                    .frame(width: activitiesViewModel.statusProgress)
                                    .frame(height: 25)
                                    .animation(Animation.easeInOut(duration: Double( 1.0)), value: activitiesViewModel.statusProgress)
                                
                                HStack(alignment: .center){
                                    Text("\(activitiesViewModel.activityCompletedByGoal.count) / \(activitiesViewModel.totalCurrentActivity)")
                                        .foregroundColor(Color("text-bar"))
                                        .padding(EdgeInsets(top: 16, leading: 12, bottom: 12, trailing: 12))
                                    
                                }.frame(width: containerWidth)
                            }.frame(width: 250, height: 25)
                               
                        }.opacity(progressBarActive ? 1 : 0)
                            .onChange(of: progressBarActive){ newValue in
                                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                    withAnimation{
                                        progressBarActive = false
                                    }
                                }
                            }
                            .onAppear(){
                                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                    
                                    withAnimation{
                                        progressBarActive = false
                                    }
                                }
                            }
                            .padding(.top, 200)
                        
                        
                        
                        Spacer()
                        
                        ZStack{
                            
                            ForEach(activitiesViewModel.filteredActivityByUser.indices, id: \.self) { idx in
                                if var status = activitiesViewModel.filteredActivityByUser[idx].status as? Bool, !status {
                                    if let actName = activitiesViewModel.filteredActivityByUser[idx].activityName, let goalName = activitiesViewModel.filteredActivityByUser[idx].goals?.goal {
                                        
                                        MorphingCircle(duration: 3.0, points: 4, secting: 2, size: 150, outerSize: 30, morphingRange: 10, idx: idx, pola: $pola, isUpdated: $updated, totalActivity: $totalActivity, isTaskActive: $isTaskActive, labelCircle: "Activity", showJournal: $showJournal, showDailyMood: $showDailyMood, isSheetMoodActive: $isSheetMoodActive, isSubmitDailyMood:$isSubmitDailyMood, activityName: actName, progressBarActive: $progressBarActive
                                        ).environmentObject(router)
                                            .environmentObject(moodsViewModel)
                                            .environmentObject(userViewModel)
                                            .environmentObject(activitiesViewModel)
                                    }
                                }
                            }
                            
                            if showJournal {
                                MorphingCircle(duration: 3.0, points: 4, secting: 2, size: 150, outerSize: 30, morphingRange: 10, idx: -1, pola: $pola, isUpdated: $updated, totalActivity: $totalActivity, isTaskActive: $isTaskActive, labelCircle: "Journal", showJournal: $showJournal, showDailyMood: $showDailyMood, isSheetMoodActive: $isSheetMoodActive, isSubmitDailyMood:$isSubmitDailyMood, progressBarActive: $progressBarActive
                                ).environmentObject(router)
                                    .environmentObject(moodsViewModel)
                                    .environmentObject(userViewModel)
                                    .environmentObject(activitiesViewModel)
                            }
                            
                            if showDailyMood{
                                MorphingCircle(duration: 3.0, points: 4, secting: 2, size: 150, outerSize: 30, morphingRange: 10, idx: -1, pola: $pola, isUpdated: $updated, totalActivity: $totalActivity, isTaskActive: $isTaskActive, labelCircle: "Daily Mood",showJournal: $showJournal, showDailyMood: $showDailyMood, isSheetMoodActive: $isSheetMoodActive, isSubmitDailyMood:$isSubmitDailyMood, progressBarActive: $progressBarActive
                                ).environmentObject(router)
                                    .environmentObject(moodsViewModel)
                                    .environmentObject(userViewModel)
                                    .environmentObject(activitiesViewModel)
                                
                                
                            }
                        }.frame(width: screenSize.width,height: screenSize.height * 0.6)
                        Image("home-bg")
                            .resizable()
                            .frame(width: 280, height: 160)
                        Spacer().frame(height: 160)
//                        statusProgress = calculateActivityDone(totalActivityProgress: totalActivityProgress, stepDone: stepDone, containerWidth: containerWidth)
                    }
                    else {
                        switch mood{
                        case "Happy":
                            Text(quotes[0])
                                .foregroundColor(Color(red: 77/255, green: 111/255, blue: 86/255))
                                .shadow(color: .gray, radius: 1, x: 0, y: 2)
                                .fontWeight(.semibold)
                            ZStack{
                                Image("happy-bg")
                                    .resizable()
                                    .frame(width: 280, height: 200)
                            }
                        case "Neutral":
                            Text(quotes[1])
                                .foregroundColor(Color(red: 77/255, green: 111/255, blue: 86/255))
                                .shadow(color: .gray, radius: 1, x: 0, y: 2)
                                .fontWeight(.semibold)
                            ZStack{
                                Image("neutral-bg")
                                    .resizable()
                                    .frame(width: 280, height: 200)
                            }
                        case "Sad":
                            Text(quotes[2])
                                .foregroundColor(Color(red: 77/255, green: 111/255, blue: 86/255))
                                .shadow(color: .gray, radius: 1, x: 0, y: 2)
                                .fontWeight(.semibold)
                            ZStack{
                                Image("sad-bg")
                                    .resizable()
                                    .frame(width: 280, height: 200)
                            }
                        default:
                            ZStack{
                                Image("home-bg")
                                    .resizable()
                                    .frame(width: 280, height: 200)
                            }.scaleEffect(scale)
                            
                                .animation(.linear(duration: 1), value: scale)
                            
                        }
                    }
                }.frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity
                )
                Spacer()
            }
        }
        .onAppear {
            activitiesViewModel.getActivities()
            if (checkStatusActivity(listDataGoal: listActivityTrue) == listAllActivity.count){
                if(!listDailyMoods.isEmpty && !listJournal.isEmpty){
                    isTaskActive = false
                }
            }
            let idUser = UUID(uuidString: UserDefaults.standard.string(forKey: "userID") ?? "")
             
            if let user = userViewModel.getUserByUserId(userId: idUser ?? UUID())  {
                moodsViewModel.getMoodsByUsers(forUser: user)
                journalsViewModel.getJournalsByUsers(forUser: user)
                goalsViewModel.getGoalsByUser(forPersonalInformation: user)
                activitiesViewModel.getAllActivityByUser(forGoals: goalsViewModel.filteredGoalsByUser)
                activitiesViewModel.countAllActivitiesByUser(forGoals: goalsViewModel.filteredGoalsByUser)
                pola = Variation(jumlah: activitiesViewModel.totalActivity).variasi
              
            }
            if !moodsViewModel.filteredMoodsByUsers.isEmpty {
                showDailyMood = false
                
            }
            if !journalsViewModel.filteredJournalsByUsers.isEmpty {
                showJournal = false
                
            }
        }
        .onChange(of: updated) { newValue in
            if newValue {
                let idUser = UUID(uuidString: UserDefaults.standard.string(forKey: "userID") ?? "")
                 
                if let user = userViewModel.getUserByUserId(userId: idUser ?? UUID())  {
                    moodsViewModel.getMoodsByUsers(forUser: user)
                    journalsViewModel.getJournalsByUsers(forUser: user)
                    goalsViewModel.getGoalsByUser(forPersonalInformation: user)
                    activitiesViewModel.getAllActivityByUser(forGoals: goalsViewModel.filteredGoalsByUser)
                    activitiesViewModel.countAllActivitiesByUser(forGoals: goalsViewModel.filteredGoalsByUser)
                    pola = Variation(jumlah: activitiesViewModel.totalActivity).variasi
                }
                updated = false
            }
        }
    }
}



public func checkStatusActivity(listDataGoal: [Goal]) -> Int {
    var countStatus: Int = 0
    for goal in listDataGoal {
        if (goal.status == true) {
            countStatus += 1
        }
        
    }
    return countStatus
}

struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        let totalActivity: Int = 3
        let pola = Variation(jumlah: totalActivity).variasi
        ActivitiesView(pola: pola)
    }
}



